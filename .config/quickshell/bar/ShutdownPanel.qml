pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Panel that slides down from a bar module and lists the session actions (logout, sleep,
// reboot, shutdown). Picking one closes the panel and runs its command detached.
// The window chrome — frame, slide animation, hover-close — lives in SlidePanel.
SlidePanel {
    id: root

    property int rowHeight: Config.barHeight
    property int rowPadding: 10

    // { icon, label, command } rows, or { separator: true } for a divider line
    property var entries: [
        { icon: "", label: "Logout",   command: ["i3-msg", "exit"] },        // sign-out-alt
        { icon: "", label: "Sleep",    command: ["systemctl", "suspend"] },  // bed
        { separator: true },
        { icon: "", label: "Reboot",   command: ["reboot"] },                // sync-alt
        { separator: true },
        { icon: "", label: "Shutdown", command: ["poweroff"] }               // power-off
    ]

    minWidth: 160

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: ScriptModel { values: root.entries }

            delegate: Rectangle {
                id: row
                required property var modelData

                readonly property bool separator: modelData.separator === true

                Layout.fillWidth: true
                Layout.preferredHeight: separator ? Config.lineSize * 2 : root.rowHeight
                implicitWidth: separator ? 0 : content.implicitWidth + 2 * root.rowPadding
                color: !separator && rowArea.containsMouse ? Colors.borderPrimary : "transparent"

                Rectangle {
                    visible: row.separator
                    anchors.centerIn: parent
                    width: parent.width - 2 * root.rowPadding
                    height: 1
                    color: Colors.foregroundAlt
                }

                Row {
                    id: content
                    visible: !row.separator
                    anchors.verticalCenter: parent.verticalCenter
                    x: root.rowPadding
                    spacing: Config.spaceWidth

                    Icon {
                        anchors.verticalCenter: parent.verticalCenter
                        // glyphs differ in width; a fixed icon column keeps the labels aligned
                        width: Config.iconPixelSize * 1.5
                        horizontalAlignment: Text.AlignHCenter
                        iconStyle: "solid"
                        color: Colors.foreground
                        text: row.modelData.icon ?? ""
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: row.modelData.label ?? ""
                    }
                }

                MouseArea {
                    id: rowArea
                    anchors.fill: parent
                    enabled: !row.separator
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.hide();
                        Quickshell.execDetached(row.modelData.command);
                    }
                }
            }
        }
    }
}
