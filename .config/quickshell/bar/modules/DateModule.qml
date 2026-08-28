import QtQuick
import qs
import qs.bar

// [module/date]: scripts/date.sh -> "Thu, Aug 28th", refreshed every 300s
Module {
    id: root

    property date now: new Date()

    function daySuffix(d) {
        switch (d) {
            case 1: case 21: case 31: return "st";
            case 2: case 22: return "nd";
            case 3: case 23: return "rd";
            default: return "th";
        }
    }

    prefix: " "
    text: Qt.formatDate(now, "ddd, MMM d") + daySuffix(now.getDate())

    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }
}
