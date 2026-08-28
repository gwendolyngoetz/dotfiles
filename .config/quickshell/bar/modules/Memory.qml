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

    function sample(contents) {
        const total = Number(contents.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0);
        const available = Number(contents.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0);
        if (total <= 0) return;

        root.percentage = Math.round((total - available) * 100 / total);
    }

    // read in-process instead of forking `awk` on every tick
    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: root.sample(meminfo.text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: meminfo.reload()
    }
}
