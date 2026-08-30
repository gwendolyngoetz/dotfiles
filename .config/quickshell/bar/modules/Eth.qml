import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar

// Local IPv4 address of the wired interface every 3s, hidden while disconnected.
// ETHERNET_INT in the environment wins; otherwise the first e* interface that is up is used.
Module {
    id: root

    property string interface: Quickshell.env("ETHERNET_INT") ?? ""
    property string localIp: ""

    active: localIp !== ""
    prefix: "\uf6ff "
    prefixStyle: "solid"
    text: localIp

    Process {
        running: root.interface === ""
        command: ["bash", "-c", `ip -o link show up | awk -F': ' '$2 ~ /^e/ {print $2; exit}'`]

        stdout: StdioCollector {
            id: detected
            onStreamFinished: root.interface = detected.text.trim()
        }
    }

    Process {
        id: proc
        command: ["bash", "-c", `ip -4 -o addr show dev "${root.interface}" up 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1`]

        stdout: StdioCollector {
            id: collector
            onStreamFinished: root.localIp = collector.text.trim()
        }
    }

    Timer {
        interval: 3000
        running: root.interface !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
