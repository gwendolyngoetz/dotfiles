import QtQuick
import qs
import qs.bar

// "3:07 PM", refreshed every 5s
Module {
    id: root

    property date now: new Date()

    prefix: " "
    text: Qt.formatTime(now, "h:mm AP")

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }
}
