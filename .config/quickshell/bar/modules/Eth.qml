import QtQuick
import Quickshell.Io
import qs
import qs.bar

// Local IPv4 address of ETHERNET_INT every 3s, hidden while disconnected
Module {
    id: root

    property string localIp: ""

    active: localIp !== ""
    prefix: " "
    prefixStyle: "solid"
    text: localIp

    Process {
        id: proc
        command: ["bash", "-c", `ip -4 -o addr show dev "${Env.ethernetInterface}" up 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1`]

        stdout: StdioCollector {
            onStreamFinished: root.localIp = this.text.trim()
        }
    }

    Timer {
        interval: 3000
        running: Env.ethernetInterface !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
