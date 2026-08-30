import QtQuick
import qs

// One bar module: margins, padding, prefix icon, background, underline and click/scroll handling.
// Hidden (zero width, no margins) when `active` is false.
Item {
    id: root

    property string text: ""
    property string prefix: ""
    property string prefixStyle: "regular"
    property color prefixColor: Colors.foregroundAlt
    property color foreground: Colors.foreground
    property color background: "transparent"
    property color underline: "transparent"
    property int padding: 0            // in spaces
    property real marginLeft: Config.moduleMarginLeft   // in spaces
    property real marginRight: Config.moduleMarginRight // in spaces
    property bool active: true
    property bool clickable: false     // pointer cursor on hover
    readonly property alias hovered: mouseArea.containsMouse
    default property alias content: slot.data

    signal leftClicked()
    signal rightClicked()
    signal middleClicked()
    signal scrolled(int delta)

    visible: active
    implicitHeight: parent?.height ?? Config.barHeight
    implicitWidth: active ? box.x + box.width + root.marginRight * Config.spaceWidth : 0

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
            id: mouseArea
            anchors.fill: parent
            z: -1
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
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
