import QtQuick
import qs

// One polybar module: module-margin-left/right, format-padding, format-prefix,
// format-background/foreground, format-underline and click/scroll handling.
// Hidden (zero width, no margins) when `active` is false, like a script with empty output.
Item {
    id: root

    property string text: ""
    property bool richText: false
    property string prefix: ""
    property string prefixStyle: "regular"
    property color prefixColor: Colors.foregroundAlt
    property color foreground: Colors.foreground
    property color background: "transparent"
    property color underline: "transparent"
    property int padding: 0            // format-padding, in spaces
    property real marginLeft: Config.moduleMarginLeft   // module-margin-left, in spaces
    property real marginRight: Config.moduleMarginRight // module-margin-right, in spaces
    property bool active: true
    property bool clickable: false     // cursor-click = pointer
    default property alias content: slot.data

    signal leftClicked()
    signal rightClicked()
    signal middleClicked()
    signal scrolled(int delta)

    visible: active
    height: parent ? parent.height : Config.barHeight
    width: active ? box.x + box.width + root.marginRight * Config.spaceWidth : 0

    Rectangle {
        id: box
        x: root.marginLeft * Config.spaceWidth
        height: parent.height
        width: row.width + 2 * root.padding * Config.spaceWidth
        color: root.background

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 0

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                visible: text !== ""
                text: root.prefix
                iconStyle: root.prefixStyle
                color: root.prefixColor
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                visible: text !== ""
                text: root.text
                textFormat: root.richText ? Text.RichText : Text.PlainText
                color: root.foreground
            }

            Item {
                id: slot
                anchors.verticalCenter: parent.verticalCenter
                width: childrenRect.width
                height: childrenRect.height
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: Config.lineSize
            color: root.underline
            visible: root.underline.a > 0
        }

        // Below the content so per-item MouseAreas (workspace boxes) get first pick of clicks
        MouseArea {
            anchors.fill: parent
            z: -1
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) root.leftClicked();
                else if (mouse.button === Qt.RightButton) root.rightClicked();
                else if (mouse.button === Qt.MiddleButton) root.middleClicked();
            }

            onWheel: wheel => root.scrolled(wheel.angleDelta.y)
        }
    }
}
