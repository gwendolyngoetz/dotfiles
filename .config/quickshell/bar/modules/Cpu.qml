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

    function sample(contents) {
        const f = contents.split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
        if (f.length < 5) return;

        const idle = f[3] + f[4];
        const total = f.reduce((a, b) => a + b, 0);

        if (root.lastTotal >= 0 && total > root.lastTotal)
            root.percentage = Math.round(100 * (1 - (idle - root.lastIdle) / (total - root.lastTotal)));

        root.lastIdle = idle;
        root.lastTotal = total;
    }

    // read in-process instead of forking `head` on every tick
    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: root.sample(stat.text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: stat.reload()
    }
}
