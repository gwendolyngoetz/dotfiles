import QtQuick
import Quickshell
import qs
import qs.bar

// "Thu, Aug 28th"; SystemClock ticks exactly at each minute boundary, so the date rolls over at midnight
Module {
    id: root

    function daySuffix(d) {
        switch (d) {
            case 1: case 21: case 31: return "st";
            case 2: case 22: return "nd";
            case 3: case 23: return "rd";
            default: return "th";
        }
    }

    prefix: " "
    text: Qt.formatDate(clock.date, "ddd, MMM d") + daySuffix(clock.date.getDate())

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
