import QtQuick
import Quickshell.Io
import qs
import qs.bar

// [module/filesystem]: interval 25, mount-0 = /, label-mounted = "%percentage_used%%"
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
            onStreamFinished: {
                root.mounted = this.text.trim() !== "";
                root.percentage = parseInt(this.text) || 0;
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
