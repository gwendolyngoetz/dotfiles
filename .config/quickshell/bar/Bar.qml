import QtQuick
import Quickshell
import qs
import qs.bar.modules

// Top bar: workspaces and spotify on the left, date and time centered, system modules on the right.
PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.barHeight
    exclusiveZone: Config.barHeight + Config.wmMargin
    color: Colors.background

    Row {
        anchors.left: parent.left
        anchors.leftMargin: Config.paddingLeft * Config.spaceWidth
        height: parent.height
        spacing: 0

        // first module: no margin, so the workspace boxes start flush with the screen edge
        Workspaces { screenName: bar.screen.name; marginLeft: 0 }
        Spotify {}
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        spacing: 0

        DateModule {}
        TimeModule {}
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Config.paddingRight * Config.spaceWidth
        height: parent.height
        spacing: 0

        Cpu {}
        Memory {}
        Filesystem {}
        Temperature {}
        Weather {}
        AirQuality {}
        Eth {}
        Otp {}
        Volume {}
        // last module: no margin, so it ends flush with the screen edge
        ShutdownMenu { marginRight: 0 }
    }
}
