pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Panel that slides down from a bar module and lists the session actions (logout, sleep,
// reboot, shutdown). Picking one closes the panel and runs its command detached.
// Closes once the pointer has left both the module and the panel.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property int minWidth: 160
    property int rowHeight: Config.barHeight
    property int rowPadding: 10

    property bool open: false

    // { icon, label, command } rows, or { separator: true } for a divider line
    property var entries: [
        { icon: "", label: "Logout",   command: ["i3-msg", "exit"] },        // sign-out-alt
        { icon: "", label: "Sleep",    command: ["systemctl", "suspend"] },  // bed
        { separator: true },
        { icon: "", label: "Reboot",   command: ["reboot"] },                // sync-alt
        { separator: true },
        { icon: "", label: "Shutdown", command: ["poweroff"] }               // power-off
    ]

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

    onAnchorHoveredChanged: if (open) closeTimer.restart()

    Rectangle {
        id: frame
        width: parent.width
        height: parent.height
        // slides down out of the bar; while closed it sits above the (clipped) window
        y: root.open ? 0 : -height
        color: Colors.background
        border.width: 1
        border.color: Colors.borderPrimary
        bottomLeftRadius: Config.panelRadius
        bottomRightRadius: Config.panelRadius
        implicitWidth: Math.max(root.minWidth, column.implicitWidth) + 2 * border.width
        implicitHeight: column.implicitHeight + 2 * border.width

        Behavior on y {
            enabled: root.visible

            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
                onRunningChanged: if (!running && !root.open) root.visible = false
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

    // small grace period so moving from the module down into the panel does not close it
    Timer {
        id: closeTimer
        interval: 400
        onTriggered: if (!hover.hovered && !root.anchorHovered) root.hide()
    }
}
