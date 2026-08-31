pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs

// Read-only panel that slides down from a bar module and shows detail rows. `entries` is a
// list of { icon, iconStyle, label, value, valueColor } objects, or { separator: true } for a
// divider line; values line up under one column, sized to the widest label (see the weather
// module). The window chrome — frame, slide animation, hover-close — lives in SlidePanel.
SlidePanel {
    id: root

    property var entries: []
    property int rowHeight: Config.barHeight
    property int rowPadding: 10

    readonly property real labelColumnWidth: labelMetrics.advanceWidth + Config.spaceWidth

    minWidth: 160

    TextMetrics {
        id: labelMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        text: root.entries.reduce((longest, e) =>
            (e.label ?? "").length > longest.length ? e.label : longest, "")
    }

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
                color: "transparent"

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
                        // glyphs differ in width; a fixed icon column keeps the labels aligned
                        width: Config.iconPixelSize * 1.5
                        horizontalAlignment: Text.AlignHCenter
                        text: row.modelData.icon ?? ""
                        iconStyle: row.modelData.iconStyle ?? "solid"
                        color: Colors.foreground
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(implicitWidth, root.labelColumnWidth)
                        text: row.modelData.label ?? ""
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: (row.modelData.value ?? "") !== ""
                        text: row.modelData.value ?? ""
                        color: row.modelData.valueColor ?? Colors.foreground
                    }
                }
            }
        }
    }
}
