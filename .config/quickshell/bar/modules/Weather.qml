import QtQuick
import Quickshell
import qs
import qs.bar

// [module/weather]: scripts/weather.sh every 900s, click-left opens weather-menu.sh
ScriptModule {
    exec: Quickshell.shellDir + "/scripts/weather.sh"
    interval: 900000
    prefix: ""
    padding: 0
    clickable: true

    onLeftClicked: Quickshell.execDetached([Quickshell.shellDir + "/scripts/weather-menu.sh"])
}
