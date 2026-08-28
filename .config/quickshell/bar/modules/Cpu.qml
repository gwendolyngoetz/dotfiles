import QtQuick
import Quickshell.Io
import qs
import qs.bar

// CPU usage from /proc/stat every 2s, left-padded to two digits
Module {
    id: root

    property real lastIdle: -1
    property real lastTotal: -1
    property int percentage: 0

    prefix: ""
    prefixStyle: "solid"
    text: String(percentage).padStart(2, " ") + "%"

    Process {
        id: proc
        command: ["head", "-n1", "/proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: {
                const f = this.text.trim().split(/\s+/).slice(1).map(Number);
                if (f.length < 5) return;

                const idle = f[3] + f[4];
                const total = f.reduce((a, b) => a + b, 0);

                if (root.lastTotal >= 0 && total > root.lastTotal)
                    root.percentage = Math.round(100 * (1 - (idle - root.lastIdle) / (total - root.lastTotal)));

                root.lastIdle = idle;
                root.lastTotal = total;
            }
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
