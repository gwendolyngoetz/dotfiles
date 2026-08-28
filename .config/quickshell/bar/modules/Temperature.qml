import QtQuick
import Quickshell.Io
import qs
import qs.bar

// TEMPERATURE_PATH (k10temp) in °C every 2s
Module {
    id: root

    property int celsius: 0
    property bool available: false

    active: available
    prefix: " "
    prefixStyle: "solid"
    text: celsius + "°C"

    Process {
        id: proc
        command: ["cat", Env.temperaturePath]

        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseInt(this.text);
                root.available = !isNaN(v);
                if (root.available) root.celsius = Math.floor(v / 1000);
            }
        }
    }

    Timer {
        interval: 2000
        running: Env.temperaturePath !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
