import QtQuick
import Quickshell
import qs
import qs.bar.modules

// [bar/secondary]: bottom = true, height = 20, background = #000000, modules-right = tray
PanelWindow {
    id: bar

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: Config.trayBarHeight
    exclusiveZone: Config.trayBarHeight + Config.wmMargin
    color: Colors.trayBarBackground

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Config.paddingRight * Config.spaceWidth
        height: parent.height
        spacing: 0

        Tray {}
    }
}
