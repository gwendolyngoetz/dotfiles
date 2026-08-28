import QtQuick
import Quickshell
import qs
import qs.bar

// scripts/weather.sh every 15 min, left click opens weather-menu.sh
ScriptModule {
    exec: Quickshell.shellDir + "/scripts/weather.sh"
    interval: 900000
    prefix: ""
    padding: 0
    clickable: true

    onLeftClicked: Quickshell.execDetached([Quickshell.shellDir + "/scripts/weather-menu.sh"])
}
