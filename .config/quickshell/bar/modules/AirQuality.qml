import QtQuick
import Quickshell
import qs
import qs.bar

// [module/airquality]: scripts/air-quality.sh every 900s (needs AIRNOW_API_* in the environment)
ScriptModule {
    exec: Quickshell.shellDir + "/scripts/air-quality.sh"
    interval: 900000
    prefix: " "
    prefixStyle: "solid"
}
