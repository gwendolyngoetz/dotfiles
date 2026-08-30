import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.bar

// PM2.5 AQI with the category initial ("42-G"), from the AirNow API with curl every 15 min.
// Needs AIRNOW_API_ZIPCODE / AIRNOW_API_KEY in the environment, otherwise the module hides;
// a failed fetch or bad JSON keeps the last reading.
Module {
    id: root

    property string zipcode: Quickshell.env("AIRNOW_API_ZIPCODE") ?? ""
    property string apiKey: Quickshell.env("AIRNOW_API_KEY") ?? ""
    readonly property bool configured: zipcode !== "" && apiKey !== ""

    property string reading: ""

    text: reading
    active: reading !== ""
    prefix: " "   // lungs
    prefixStyle: "solid"

    Process {
        id: fetcher
        command: ["curl", "-sfL", "https://www.airnowapi.org/aq/observation/zipCode/current/"
            + `?format=application/json&zipCode=${root.zipcode}&API_KEY=${root.apiKey}`]

        stdout: StdioCollector { id: fetcherOut }

        onExited: exitCode => {
            if (exitCode !== 0) return;

            try {
                const pm = JSON.parse(fetcherOut.text).find(o => o.ParameterName === "PM2.5");
                if (pm) root.reading = `${pm.AQI}-${(pm.Category?.Name ?? "?").charAt(0)}`;
            } catch (e) {}
        }
    }

    Timer {
        interval: 900000
        running: root.configured
        repeat: true
        triggeredOnStart: true
        onTriggered: fetcher.running = true
    }
}
