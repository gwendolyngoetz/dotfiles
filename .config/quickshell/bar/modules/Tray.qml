import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs

// System tray icons
Row {
    id: root
    height: parent ? parent.height : Config.trayBarHeight
    spacing: 0

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: item
            required property SystemTrayItem modelData

            height: root.height
            width: Config.trayIconSize + 2 * Config.trayPadding

            IconImage {
                anchors.centerIn: parent
                implicitSize: Config.trayIconSize
                source: item.modelData.icon
            }

            QsMenuAnchor {
                id: menu
                menu: item.modelData.menu
                anchor.window: item.QsWindow.window
                anchor.item: item
                anchor.edges: Edges.Top
                anchor.gravity: Edges.Top
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton && !item.modelData.onlyMenu) item.modelData.activate();
                    else if (mouse.button === Qt.MiddleButton) item.modelData.secondaryActivate();
                    else if (item.modelData.hasMenu) menu.open();
                }

                onWheel: wheel => item.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
