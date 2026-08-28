import QtQuick
import Quickshell.Io
import qs
import qs.bar

// Used memory percentage ((MemTotal - MemAvailable) / MemTotal) every 2s
Module {
    id: root

    property int percentage: 0

    prefix: " "
    prefixStyle: "solid"
    text: percentage + "%"

    Process {
        id: proc
        command: ["awk", "/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf \"%d\", (t-a)*100/t + 0.5}", "/proc/meminfo"]

        stdout: StdioCollector {
            onStreamFinished: root.percentage = parseInt(this.text) || 0
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
