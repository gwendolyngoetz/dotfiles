import QtQuick
import Quickshell.Io
import qs

// Run `exec` every `interval` ms, show its output, hide when the output is empty.
Module {
    id: root

    property string exec: ""
    property int interval: 5000
    property string output: ""

    text: output
    active: output !== ""

    Process {
        id: proc
        command: ["bash", "-c", root.exec]

        stdout: StdioCollector {
            id: collector
            onStreamFinished: root.output = collector.text.trim().replace(/\n+/g, " ")
        }
    }

    Timer {
        interval: root.interval
        running: root.exec !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
