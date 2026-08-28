import QtQuick
import Quickshell
import Quickshell.I3
import Quickshell.Io
import qs
import qs.bar

// i3 workspaces on this output, followed by the binding mode when one is active
Module {
    id: root

    required property string screenName
    property string mode: "default"

    // only workspaces on this bar's output, sorted by number
    readonly property var workspaces: I3.workspaces.values
        .filter(ws => ws.monitor && ws.monitor.name === root.screenName)
        .sort((a, b) => a.num - b.num)

    // "1:1" -> "1", "10:<icon>" -> "<icon>"
    function stripNumber(name) {
        const idx = name.indexOf(":");
        return idx >= 0 ? name.slice(idx + 1) : name;
    }

    Row {
        spacing: 0

        Repeater {
            model: root.workspaces

            delegate: Rectangle {
                id: item
                required property var modelData

                height: root.height
                width: label.width + 2 * Config.i3Padding * Config.spaceWidth
                color: modelData.focused ? Colors.borderPrimary
                     : modelData.urgent ? Colors.alert
                     : modelData.active ? Colors.backgroundAlt
                     : "transparent"

                Label {
                    id: label
                    anchors.centerIn: parent
                    // Workspace names mix digits and FA glyphs; rely on fontconfig fallback
                    text: root.stripNumber(item.modelData.name)
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: I3.dispatch("workspace number " + item.modelData.num)
                }
            }
        }

        // gap before the mode label
        Label { text: " " }

        // binding mode, shown while in one (e.g. resize)
        Rectangle {
            visible: root.mode !== "default"
            height: root.height
            width: modeLabel.width + 2 * Config.i3Padding * Config.spaceWidth
            color: Colors.primary

            Label {
                id: modeLabel
                anchors.centerIn: parent
                text: root.mode
                color: "#000"
            }
        }
    }

    Process {
        id: modeWatcher
        command: ["i3-msg", "-t", "subscribe", "-m", "[\"mode\"]"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                try {
                    root.mode = JSON.parse(line).change;
                } catch (e) {}
            }
        }

        // i3-msg exits when i3 restarts; resubscribe
        onExited: restart.start()
    }

    Timer {
        id: restart
        interval: 1000
        onTriggered: modeWatcher.running = true
    }
}
