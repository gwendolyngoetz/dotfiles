import QtQuick
import Quickshell
import qs
import qs.bar

// scripts/air-quality.sh every 15 min (needs AIRNOW_API_* in the environment)
ScriptModule {
    exec: Quickshell.shellDir + "/scripts/air-quality.sh"
    interval: 900000
    prefix: " "
    prefixStyle: "solid"
}
