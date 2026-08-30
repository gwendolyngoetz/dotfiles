import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar

// CPU die temperature in °C every 2s, hidden when no sensor is found.
// TEMPERATURE_PATH in the environment wins. Otherwise the hwmon tree is scanned once by label:
// "Tdie" (AMD k10temp) or "Package id N" (Intel coretemp) first, "Tctl" as a fallback — Tctl is
// a control value with a vendor offset on some Ryzen parts. hwmon numbering changes across
// reboots, so the lookup is by label rather than by path.
Module {
    id: root

    property string sensorPath: Quickshell.env("TEMPERATURE_PATH") ?? ""
    property int celsius: -1   // -1: sensor missing or unreadable

    active: celsius >= 0
    prefix: "\uf2c9 "
    prefixStyle: "solid"
    text: celsius + "°C"

    Process {
        running: root.sensorPath === ""
        command: ["bash", "-c", `
            best=""; fallback=""
            for l in /sys/class/hwmon/hwmon*/temp*_label; do
                case "$(cat "$l" 2>/dev/null)" in
                    Tdie|"Package id "*) best="\${l%_label}_input"; break ;;
                    Tctl)                fallback="\${l%_label}_input" ;;
                esac
            done
            echo "\${best:-$fallback}"
        `]

        stdout: StdioCollector {
            id: detected
            onStreamFinished: root.sensorPath = detected.text.trim()
        }
    }

    // setting `path` loads once; the timer keeps it fresh
    FileView {
        id: sensor
        path: root.sensorPath
        printErrors: false

        onLoaded: {
            const v = parseInt(sensor.text());
            root.celsius = isNaN(v) ? -1 : Math.floor(v / 1000);
        }

        onLoadFailed: root.celsius = -1
    }

    Timer {
        interval: 2000
        running: root.sensorPath !== ""
        repeat: true
        onTriggered: sensor.reload()
    }
}
