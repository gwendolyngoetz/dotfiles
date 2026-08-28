import QtQuick
import Quickshell
import qs
import qs.bar.modules

// [bar/main]
// modules-left   = i3 spotify
// modules-center = date time
// modules-right  = cpu memory filesystem temperature weather airquality eth otp pulseaudio shutdown-menu
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

    Item {
        anchors.fill: parent

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Config.paddingLeft * Config.spaceWidth
            height: parent.height
            spacing: 0

            // first module: no margin, so the workspace boxes start flush with the screen edge
            Workspaces { screenName: bar.screen.name; marginLeft: 0 }
            Spotify {}
        }

        // fixed-center = true
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
}
