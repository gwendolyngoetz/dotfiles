pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs

// Panel that slides down from a bar module and lists the password-store entries, grouped into
// tabs by pass's native folder layout (`work/github.gpg` is `github` on the `work` tab; entries
// at the top level of the store land on the `ungroupedName` tab). Picking one
// runs `pass otp <name>`, copies the code to the clipboard and shows it next to the entry with
// a bar draining over the TOTP period; the code is regenerated when the period rolls over. The
// clipboard is cleared `clipboardTtl` ms after the last copy if it still holds our code.
// `copy(name)` does the same without opening the panel and reports through notify-send.
// The window chrome — frame, slide animation, hover-close — lives in SlidePanel.
SlidePanel {
    id: root

    property string store: Quickshell.env("PASSWORD_STORE_DIR") ?? (Quickshell.env("HOME") + "/.password-store")
    property int period: 30            // TOTP step in seconds
    property int clipboardTtl: 45000   // ms until the clipboard is cleared again
    property string ungroupedName: "other"
    property string defaultGroup: "tools"      // tab selected whenever the panel opens
    property var hiddenGroups: ["archive"]     // groups left out of the panel entirely
    property int rowHeight: Config.barHeight
    property int rowPadding: 10

    property string account: ""   // entry whose code is shown
    property string code: ""
    property string error: ""
    property string copied: ""    // last code put on the clipboard
    property string group: ""     // selected tab

    // [{ name, group, label }] for every *.gpg in the store, sorted by name; `name` is the
    // path pass wants (`work/github`), `label` the part shown on the tab (`github`)
    property var accounts: []
    readonly property var groups: [...new Set(accounts.map(a => a.group))].sort()
    readonly property var rows: accounts.filter(a => a.group === group)

    // the name column is sized to the longest label of any group, so switching tabs does not resize the panel
    readonly property string longestLabel: accounts.reduce((l, a) => a.label.length > l.length ? a.label : l, "")

    // width of the code / error column, from metrics only — sizing the label off its own
    // implicitWidth loops through the row layout
    readonly property real detailWidth: Math.max(codeMetrics.advanceWidth,
        error !== "" ? errorMetrics.advanceWidth : 0)

    readonly property int nowSeconds: Math.floor(clock.date.getTime() / 1000)
    readonly property int remaining: period - nowSeconds % period
    readonly property int step: Math.floor(nowSeconds / period)

    minWidth: 200

    // refresh the store listing and land on the default tab on every open
    onAboutToShow: {
        lister.running = true;
        if (root.groups.includes(root.defaultGroup)) root.group = root.defaultGroup;
    }

    // wipe the shown code once the close slide has finished
    onCloseFinished: root.reset()

    // generate the code for `name` and put it on the clipboard
    function copy(name) {
        if (otp.running) return;

        root.account = name;
        root.code = "";
        root.error = "";
        otp.command = ["pass", "otp", name];
        otp.running = true;
    }

    function reset() {
        root.account = "";
        root.code = "";
        root.error = "";
    }

    // "work/github" -> the `github` row on the `work` tab; "personal/aws/prod" stays
    // "aws/prod" on the `personal` tab; a top-level "email" goes on the `ungroupedName` tab
    function parse(name) {
        const idx = name.indexOf("/");
        return idx > 0
            ? { name, group: name.slice(0, idx), label: name.slice(idx + 1) }
            : { name, group: root.ungroupedName, label: name };
    }

    // "482913" -> "482 913"
    function formatCode(c) {
        return c.replace(/^(\d{3})(\d{3})$/, "$1 $2");
    }

    // a shown code is stale once the period rolls over
    onStepChanged: if (open && account !== "" && code !== "") copy(account)

    // gated on visible, not on the code: the code is written from onStepChanged, which the
    // clock itself drives, so enabling the clock from it is a binding loop
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        enabled: root.visible
    }

    // Every *.gpg under the store as store-relative paths, pruning dot dirs (.git, .extensions).
    // -mindepth keeps the prune off the store root itself, which is a dot dir (~/.password-store).
    Process {
        id: lister
        command: ["find", "-L", root.store, "-mindepth", "1", "-name", ".*", "-prune",
            "-o", "-type", "f", "-name", "*.gpg", "-printf", "%P\n"]
        running: true

        stdout: StdioCollector {
            id: listerOut

            onStreamFinished: {
                root.accounts = listerOut.text.split("\n")
                    .filter(l => l !== "")
                    .map(l => root.parse(l.replace(/\.gpg$/, "")))
                    .filter(a => !root.hiddenGroups.includes(a.group))
                    .sort((a, b) => a.label.localeCompare(b.label));

                if (root.group === "" && root.groups.includes(root.defaultGroup))
                    root.group = root.defaultGroup;
                if (!root.groups.includes(root.group)) root.group = root.groups[0] ?? "";
            }
        }
    }

    Process {
        id: otp

        stdout: StdioCollector { id: otpOut }
        stderr: StdioCollector { id: otpErr }

        onExited: exitCode => {
            if (exitCode === 0) {
                root.code = otpOut.text.trim();
                root.error = "";
                root.copied = root.code;
                clip.stdinEnabled = true;
                clip.running = true;
                clearTimer.restart();

                if (!root.open)
                    Quickshell.execDetached(["notify-send", "-u", "normal", "-t", "1000", "OTP", `${root.account} copied to clipboard`]);
            } else {
                root.code = "";
                root.error = otpErr.text.trim().split("\n").pop() || `pass otp ${root.account} failed`;

                if (!root.open)
                    Quickshell.execDetached(["notify-send", "-u", "critical", "-t", "3000", "OTP", root.error]);
            }
        }
    }

    // xclip reads the code from stdin, then forks to serve the selection
    Process {
        id: clip
        command: ["xclip", "-selection", "clipboard"]
        stdinEnabled: true

        onStarted: {
            clip.write(root.copied);
            clip.stdinEnabled = false;
        }
    }

    // clear the clipboard after the ttl, but only if it still holds the code we put there
    Timer {
        id: clearTimer
        interval: root.clipboardTtl
        onTriggered: clipCheck.running = true
    }

    Process {
        id: clipCheck
        command: ["xclip", "-o", "-selection", "clipboard"]

        stdout: StdioCollector {
            id: clipText
            onStreamFinished: if (clipText.text === root.copied) clipClear.running = true
        }
    }

    Process {
        id: clipClear
        command: ["xclip", "-selection", "clipboard", "/dev/null"]
    }

    // the code column keeps its width so the panel does not resize when a code appears
    TextMetrics {
        id: codeMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        font.bold: true
        text: "000 000"
    }

    TextMetrics {
        id: errorMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        text: root.error
    }

    TextMetrics {
        id: nameMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        text: root.longestLabel
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: 0

        // one tab per group; hidden when there is only one
        Row {
            visible: root.groups.length > 1
            Layout.fillWidth: true
            Layout.preferredHeight: root.rowHeight
            spacing: 0

            Repeater {
                model: ScriptModel { values: root.groups }

                delegate: Rectangle {
                    id: tab
                    required property string modelData

                    readonly property bool current: root.group === modelData

                    height: root.rowHeight
                    width: tabLabel.width + 2 * root.rowPadding
                    color: current ? Colors.primary
                         : tabArea.containsMouse ? Colors.backgroundAlt
                         : "transparent"

                    Label {
                        id: tabLabel
                        anchors.centerIn: parent
                        text: tab.modelData
                        color: Colors.foreground
                    }

                    MouseArea {
                        id: tabArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.group = tab.modelData
                    }
                }
            }
        }

        Rectangle {
            visible: root.groups.length > 1
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Colors.foregroundAlt
        }

        // empty store
        Label {
            visible: root.accounts.length === 0
            Layout.preferredHeight: root.rowHeight
            leftPadding: root.rowPadding
            rightPadding: root.rowPadding
            text: "No entries in " + root.store
            color: Colors.foregroundAlt
        }

        Repeater {
            model: ScriptModel { values: root.rows }

            delegate: Rectangle {
                id: row
                required property var modelData

                readonly property bool selected: root.account === modelData.name
                readonly property string detail: !selected ? ""
                    : root.error !== "" ? root.error
                    : root.code !== "" ? root.formatCode(root.code)
                    : "…"

                Layout.fillWidth: true
                Layout.preferredHeight: root.rowHeight
                // icon, the widest name of any group, a gap, then the code column; an error message may be wider than a code
                implicitWidth: icon.width + content.spacing + nameMetrics.advanceWidth + 3 * Config.spaceWidth + root.detailWidth + 2 * root.rowPadding
                color: rowArea.containsMouse ? Colors.borderPrimary : "transparent"

                Row {
                    id: content
                    anchors.verticalCenter: parent.verticalCenter
                    x: root.rowPadding
                    spacing: Config.spaceWidth

                    Icon {
                        id: icon
                        anchors.verticalCenter: parent.verticalCenter
                        iconStyle: "solid"
                        color: Colors.foreground
                        text: ""   // key
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: row.modelData.label
                    }
                }

                Label {
                    id: detailLabel
                    anchors.right: parent.right
                    anchors.rightMargin: root.rowPadding
                    anchors.verticalCenter: parent.verticalCenter
                    width: root.detailWidth
                    horizontalAlignment: Text.AlignRight
                    font.bold: root.error === ""
                    text: row.detail
                    color: root.error !== "" && row.selected ? Colors.alert : Colors.foreground
                }

                // time left in the current TOTP period
                Rectangle {
                    visible: row.selected && root.code !== ""
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    height: Config.lineSize
                    width: parent.width * root.remaining / root.period
                    color: Colors.primary

                    Behavior on width {
                        enabled: root.remaining < root.period
                        NumberAnimation { duration: 1000 }
                    }
                }

                MouseArea {
                    id: rowArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.copy(row.modelData.name)
                }
            }
        }
    }
}
