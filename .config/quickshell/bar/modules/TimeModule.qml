import QtQuick
import Quickshell
import qs
import qs.bar

// "3:07 PM"; SystemClock ticks exactly at each minute boundary
Module {
    id: root

    prefix: " "
    text: Qt.formatTime(clock.date, "h:mm AP")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
