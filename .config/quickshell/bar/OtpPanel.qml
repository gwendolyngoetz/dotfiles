pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs

// Panel that slides down from a bar module and lists the password-store entries. Picking one
// runs `pass otp <name>`, copies the code to the clipboard and shows it next to the entry with
// a bar draining over the TOTP period; the code is regenerated when the period rolls over. The
// clipboard is cleared `clipboardTtl` ms after the last copy if it still holds our code.
// `copy(name)` does the same without opening the panel and reports through notify-send.
// Closes once the pointer has left both the module and the panel.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property string store: Quickshell.env("PASSWORD_STORE_DIR") ?? (Quickshell.env("HOME") + "/.password-store")
    property int period: 30            // TOTP step in seconds
    property int clipboardTtl: 45000   // ms until the clipboard is cleared again
    property int minWidth: 200
    property int rowHeight: Config.barHeight
    property int rowPadding: 10

    property bool open: false
    property string account: ""   // entry whose code is shown
    property string code: ""
    property string error: ""
    property string copied: ""    // last code put on the clipboard

    readonly property int nowSeconds: Math.floor(clock.date.getTime() / 1000)
    readonly property int remaining: period - nowSeconds % period
    readonly property int step: Math.floor(nowSeconds / period)

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right

    visible: false
    color: "transparent"
    implicitWidth: frame.implicitWidth
    implicitHeight: frame.implicitHeight

    function show() {
        // the module drifts as modules left of it change width; re-anchor before each show
        root.anchor.updateAnchor();
        root.visible = true;
        root.open = true;
    }

    function hide() {
        root.open = false;
    }

    function toggle() {
        if (root.open) hide(); else show();
    }

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

    // "482913" -> "482 913"
    function formatCode(c) {
        return c.replace(/^(\d{3})(\d{3})$/, "$1 $2");
    }

    onAnchorHoveredChanged: if (open) closeTimer.restart()

    // a shown code is stale once the period rolls over
    onStepChanged: if (open && account !== "" && code !== "") copy(account)

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        enabled: root.code !== ""
    }

    FolderListModel {
        id: entries
        folder: "file://" + root.store
        nameFilters: ["*.gpg"]
        showDirs: false
        showDotAndDotDot: false
        sortField: FolderListModel.Name
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

    Rectangle {
        id: frame
        width: parent.width
        height: parent.height
        // slides down out of the bar; while closed it sits above the (clipped) window
        y: root.open ? 0 : -height
        color: Colors.background
        border.width: 1
        border.color: Colors.borderPrimary
        implicitWidth: Math.max(root.minWidth, column.implicitWidth) + 2 * border.width
        implicitHeight: column.implicitHeight + 2 * border.width

        Behavior on y {
            enabled: root.visible

            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
                onRunningChanged: {
                    if (running || root.open) return;

                    root.visible = false;
                    root.reset();
                }
            }
        }

        HoverHandler {
            id: hover
            onHoveredChanged: if (root.open) closeTimer.restart()
        }

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: frame.border.width
            spacing: 0

            // empty store
            Label {
                visible: entries.count === 0
                Layout.preferredHeight: root.rowHeight
                leftPadding: root.rowPadding
                rightPadding: root.rowPadding
                text: "No entries in " + root.store
                color: Colors.foregroundAlt
            }

            Repeater {
                model: entries

                delegate: Rectangle {
                    id: row
                    required property string fileBaseName

                    readonly property bool selected: root.account === fileBaseName
                    readonly property string detail: !selected ? ""
                        : root.error !== "" ? root.error
                        : root.code !== "" ? root.formatCode(root.code)
                        : "…"

                    Layout.fillWidth: true
                    Layout.preferredHeight: root.rowHeight
                    // name column, a gap, then the code column; an error message may be wider than a code
                    implicitWidth: content.implicitWidth + 3 * Config.spaceWidth + detailLabel.width + 2 * root.rowPadding
                    color: rowArea.containsMouse ? Colors.borderPrimary : "transparent"

                    Row {
                        id: content
                        anchors.verticalCenter: parent.verticalCenter
                        x: root.rowPadding
                        spacing: Config.spaceWidth

                        Icon {
                            anchors.verticalCenter: parent.verticalCenter
                            iconStyle: "solid"
                            color: Colors.foreground
                            text: ""   // key
                        }

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: row.fileBaseName
                        }
                    }

                    Label {
                        id: detailLabel
                        anchors.right: parent.right
                        anchors.rightMargin: root.rowPadding
                        anchors.verticalCenter: parent.verticalCenter
                        width: row.selected && root.error !== "" ? implicitWidth : codeMetrics.advanceWidth
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
                        onClicked: root.copy(row.fileBaseName)
                    }
                }
            }
        }
    }

    // small grace period so moving from the module down into the panel does not close it
    Timer {
        id: closeTimer
        interval: 400
        onTriggered: if (!hover.hovered && !root.anchorHovered) root.hide()
    }
}
