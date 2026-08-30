pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Widgets
import qs

// Launcher contents: prompt, search entry and the filtered application list.
Item {
    id: root

    property string query: ""
    property alias currentIndex: list.currentIndex

    signal accepted()
    signal dismissed()

    readonly property string fontFamily: "Roboto Mono"
    readonly property int fontPointSize: 13
    readonly property int spacing: 0

    // every whitespace-separated token must appear (case-insensitive) in one of
    // name, generic name, exec, categories, keywords or comment
    readonly property var entries: {
        const tokens = query.toLowerCase().split(/\s+/).filter(t => t !== "");

        return DesktopEntries.applications.values
            .filter(e => !e.noDisplay)
            .filter(e => {
                if (tokens.length === 0) return true;

                const fields = [e.name, e.genericName, e.execString, e.comment,
                    (e.categories ?? []).join(" "), (e.keywords ?? []).join(" ")]
                    .map(f => (f ?? "").toLowerCase());

                return tokens.every(t => fields.some(f => f.indexOf(t) >= 0));
            })
            .sort((a, b) => a.name.localeCompare(b.name, undefined, { sensitivity: "base" }));
    }

    function focusEntry() {
        entry.forceActiveFocus();
    }

    function move(delta) {
        if (list.count === 0) return;
        list.currentIndex = Math.min(list.count - 1, Math.max(0, list.currentIndex + delta));
    }

    function activate(index) {
        const e = root.entries[index];
        if (!e) return;

        e.execute();
        root.accepted();
    }

    onQueryChanged: list.currentIndex = 0

    // close when the window loses focus
    property bool hadFocus: false
    readonly property bool windowActive: Window.active
    onWindowActiveChanged: {
        if (windowActive) hadFocus = true;
        else if (hadFocus) { hadFocus = false; root.dismissed(); }
    }

    Rectangle {
        id: mainbox
        anchors.fill: parent
        color: Colors.launcherBg
        border.width: 1
        border.color: Colors.launcherAccent

        Column {
            anchors.fill: parent
            anchors.margins: 1
            topPadding: 20
            bottomPadding: 20
            spacing: 20

            // input bar: prompt, colon, entry
            Row {
                id: inputbar
                x: 20
                width: parent.width - 40
                spacing: root.spacing

                Text {
                    id: prompt
                    text: "drun"
                    color: Colors.launcherAccent
                    font.family: root.fontFamily
                    font.pointSize: root.fontPointSize
                }

                Text {
                    id: colon
                    text: ":"
                    color: Colors.launcherAccent
                    font.family: root.fontFamily
                    font.pointSize: root.fontPointSize
                    rightPadding: chMetrics.advanceWidth
                }

                TextInput {
                    id: entry
                    width: inputbar.width - prompt.width - colon.width
                    color: Colors.launcherFg
                    selectionColor: Colors.launcherAccent
                    font.family: root.fontFamily
                    font.pointSize: root.fontPointSize
                    focus: true
                    text: root.query
                    onTextChanged: root.query = text

                    Keys.onPressed: event => {
                        const ctrl = event.modifiers & Qt.ControlModifier;

                        switch (event.key) {
                        case Qt.Key_Escape:
                            root.dismissed(); break;
                        case Qt.Key_BracketLeft:
                            if (!ctrl) return;
                            root.dismissed(); break;
                        case Qt.Key_G:
                            if (!ctrl) return;
                            root.dismissed(); break;
                        case Qt.Key_Return:
                        case Qt.Key_Enter:
                            root.activate(list.currentIndex); break;
                        case Qt.Key_Down:
                            root.move(1); break;
                        case Qt.Key_Up:
                            root.move(-1); break;
                        case Qt.Key_Tab:
                            root.move(1); break;
                        case Qt.Key_Backtab:
                            root.move(-1); break;
                        case Qt.Key_N:
                            if (!ctrl) return;
                            root.move(1); break;
                        case Qt.Key_P:
                            if (!ctrl) return;
                            root.move(-1); break;
                        case Qt.Key_PageDown:
                            root.move(list.visibleRows); break;
                        case Qt.Key_PageUp:
                            root.move(-list.visibleRows); break;
                        case Qt.Key_Home:
                            if (!ctrl) return;
                            list.currentIndex = 0; break;
                        case Qt.Key_End:
                            if (!ctrl) return;
                            list.currentIndex = list.count - 1; break;
                        default:
                            return;
                        }

                        event.accepted = true;
                    }
                }
            }

            // application list with scrollbar
            Item {
                id: listArea
                x: 20
                width: parent.width - 30
                height: parent.height - parent.topPadding - parent.bottomPadding - inputbar.height - parent.spacing

                ListView {
                    id: list
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width - scrollbar.width - 20
                    clip: true
                    spacing: 5
                    // ScriptModel diffs by object identity, so rows that survive a keystroke are reused
                    model: ScriptModel { values: root.entries }
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0
                    keyNavigationEnabled: false
                    boundsBehavior: Flickable.StopAtBounds

                    readonly property int rowHeight: entryMetrics.height + 10 + spacing
                    readonly property int visibleRows: Math.max(1, Math.floor(height / rowHeight))

                    delegate: Rectangle {
                        id: element
                        required property DesktopEntry modelData
                        required property int index

                        width: ListView.view.width
                        height: elementRow.height + 10
                        color: ListView.isCurrentItem ? Colors.launcherAccent : Colors.launcherBg

                        Row {
                            id: elementRow
                            x: 5
                            y: 5
                            width: parent.width - 10
                            spacing: 5

                            IconImage {
                                anchors.verticalCenter: parent.verticalCenter
                                implicitSize: entryMetrics.height
                                source: Quickshell.iconPath(element.modelData.icon, "application-x-executable")
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - entryMetrics.height - parent.spacing
                                text: element.modelData.name
                                color: Colors.launcherFg
                                font.family: root.fontFamily
                                font.pointSize: root.fontPointSize
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: list.currentIndex = element.index
                            onClicked: root.activate(element.index)
                        }
                    }

                    // keep the highlighted row on screen without animating
                    onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)
                }

                Rectangle {
                    id: scrollbar
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 10 + 2
                    color: Colors.launcherAlt
                    border.width: 0

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: Colors.launcherAccent
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: Colors.launcherAccent
                    }

                    Rectangle {
                        x: 1
                        width: 10
                        color: Colors.launcherAccent
                        visible: list.contentHeight > list.height
                        height: list.contentHeight > 0
                            ? Math.max(4, scrollbar.height * list.height / list.contentHeight)
                            : scrollbar.height
                        y: list.contentHeight > list.height
                            ? (scrollbar.height - height) * list.contentY / (list.contentHeight - list.height)
                            : 0
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: mouse => {
                            if (list.contentHeight <= list.height) return;
                            list.contentY = (mouse.y / height) * (list.contentHeight - list.height);
                        }
                    }
                }
            }
        }
    }

    TextMetrics {
        id: chMetrics
        font.family: root.fontFamily
        font.pointSize: root.fontPointSize
        text: "0"
    }

    TextMetrics {
        id: entryMetrics
        font.family: root.fontFamily
        font.pointSize: root.fontPointSize
        text: "Ag"
    }
}
