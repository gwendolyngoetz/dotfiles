import QtQuick
import Quickshell.Io
import qs
import qs.bar

// Used percentage of `mount` every 25s
Module {
    id: root

    property string mount: "/"
    property int percentage: 0
    property bool mounted: true

    prefix: " "
    text: mounted ? percentage + "%" : mount + " not mounted"
    foreground: mounted ? Colors.foreground : Colors.foregroundAlt

    Process {
        id: proc
        command: ["bash", "-c", `df -P -B1 "${root.mount}" | awk 'NR==2 {printf "%d", $3*100/($3+$4) + 0.5}'`]

        stdout: StdioCollector {
            id: collector

            onStreamFinished: {
                root.mounted = collector.text.trim() !== "";
                root.percentage = parseInt(collector.text) || 0;
            }
        }
    }

    Timer {
        interval: 25000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
