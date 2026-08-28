import QtQuick
import Quickshell.Io
import qs
import qs.bar

// TEMPERATURE_PATH (k10temp) in °C every 2s
Module {
    id: root

    property int celsius: 0
    property bool available: false

    active: available
    prefix: " "
    prefixStyle: "solid"
    text: celsius + "°C"

    // read the hwmon file in-process; an empty path (sensor not found) loads nothing
    FileView {
        id: sensor
        path: Env.temperaturePath
        printErrors: false

        onLoaded: {
            const v = parseInt(sensor.text());
            root.available = !isNaN(v);
            if (root.available) root.celsius = Math.floor(v / 1000);
        }

        onLoadFailed: root.available = false
    }

    Timer {
        interval: 2000
        running: Env.temperaturePath !== ""
        repeat: true
        onTriggered: sensor.reload()
    }
}
