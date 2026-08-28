pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Popup menu hanging off a bar module. `entries` is a list of
// { icon, iconStyle, label } objects, or { separator: true } for a divider line. An entry may
// also carry { value, valueColor } to show a read-only detail column (see the weather popup);
// set `interactive: false` for a popup that only displays information.
// Closes after an entry is picked, or once the pointer has left both the module and the menu.
PopupWindow {
    id: root

    required property Item anchorItem
    property var entries: []
    property bool anchorHovered: false
    property int minWidth: 160
    property int rowHeight: Config.barHeight
    property int rowPadding: 10
    property bool interactive: true

    signal activated(var entry)

    // value rows line their values up under one column, sized to the widest label
    readonly property real labelColumnWidth: labelMetrics.advanceWidth + Config.spaceWidth

    TextMetrics {
        id: labelMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        text: root.entries.reduce((longest, e) =>
            (e.value ?? "") !== "" && (e.label ?? "").length > longest.length ? e.label : longest, "")
    }

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right

    visible: false
    color: "transparent"
    implicitWidth: frame.implicitWidth
    implicitHeight: frame.implicitHeight

    function toggle() {
        // the module drifts as modules left of it change width; re-anchor before each show
        if (!root.visible) root.anchor.updateAnchor();

        root.visible = !root.visible;
    }

    onAnchorHoveredChanged: if (visible) closeTimer.restart()

    Rectangle {
        id: frame
        anchors.fill: parent
        color: Colors.background
        border.width: 1
        border.color: Colors.borderPrimary
        implicitWidth: Math.max(root.minWidth, column.implicitWidth) + 2 * border.width
        implicitHeight: column.implicitHeight + 2 * border.width

        HoverHandler {
            id: hover
            onHoveredChanged: if (root.visible) closeTimer.restart()
        }

        // ColumnLayout's implicit width is the widest row, which sizes the menu to its content
        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: frame.border.width
            spacing: 0

            Repeater {
                model: root.entries

                delegate: Rectangle {
                    id: row
                    required property var modelData

                    readonly property bool separator: modelData.separator === true
                    readonly property bool hasValue: (modelData.value ?? "") !== ""

                    Layout.fillWidth: true
                    Layout.preferredHeight: separator ? Config.lineSize * 2 : root.rowHeight
                    implicitWidth: separator ? 0 : content.implicitWidth + 2 * root.rowPadding
                    color: root.interactive && !separator && rowArea.containsMouse ? Colors.borderPrimary : "transparent"

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
                            visible: text !== ""
                            // glyphs differ in width; give value rows a fixed icon column
                            width: row.hasValue ? Config.iconPixelSize * 1.5 : implicitWidth
                            horizontalAlignment: Text.AlignHCenter
                            text: row.modelData.icon ?? ""
                            iconStyle: row.modelData.iconStyle ?? "solid"
                            color: Colors.foreground
                        }

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: row.hasValue ? Math.max(implicitWidth, root.labelColumnWidth) : implicitWidth
                            text: row.modelData.label ?? ""
                        }

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: row.hasValue
                            text: row.modelData.value ?? ""
                            color: row.modelData.valueColor ?? Colors.foreground
                        }
                    }

                    MouseArea {
                        id: rowArea
                        anchors.fill: parent
                        enabled: !row.separator
                        hoverEnabled: true
                        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor

                        onClicked: {
                            root.visible = false;
                            if (root.interactive) root.activated(row.modelData);
                        }
                    }
                }
            }
        }
    }

    // small grace period so moving from the module down into the menu does not close it
    Timer {
        id: closeTimer
        interval: 400
        onTriggered: if (!hover.hovered && !root.anchorHovered) root.visible = false
    }
}
