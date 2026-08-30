import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.bar

// Current temperature with a condition icon, every 15 min. scripts/weather.sh fetches the
// OpenWeatherMap one-call response into scripts/.weather.json; everything shown comes from
// that file. Left click opens a popup with the details.
Module {
    id: root

    // one-call responses carry no place name
    property string city: "Renton"
    property int forecastHours: 12   // window for the high / low
    property var data: null

    readonly property var current: data?.current ?? null
    readonly property bool day: current !== null
        && current.dt >= current.sunrise && current.dt <= current.sunset

    active: current !== null
    prefix: current ? conditionIcon(current.weather?.[0]?.id ?? -1, day) + " " : ""
    prefixStyle: "solid"
    text: current ? formatTemp(current.temp) : ""
    padding: 0
    clickable: true

    function formatTemp(v) {
        return `${Math.round(v)}°F`;
    }

    function formatTime(unix) {
        return Qt.formatTime(new Date(unix * 1000), "h:mm AP");
    }

    // https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2, as Font Awesome 5 glyphs
    function conditionIcon(code, day) {
        if (code === 800) return day ? "\uf185" : "\uf186";                 // sun / moon
        if (code >= 801 && code <= 804) return day ? "\uf6c4" : "\uf6c3";   // cloud-sun / cloud-moon
        if (code >= 500 && code <= 531) return "\uf740";                    // cloud-showers-heavy
        if (code >= 300 && code <= 321) return day ? "\uf743" : "\uf73c";   // cloud-sun-rain / cloud-moon-rain
        if (code >= 200 && code <= 232) return "\uf0e7";                    // bolt
        if (code >= 600 && code <= 622) return "\uf2dc";                    // snowflake
        if (code === 781) return "\uf72e";                                  // wind (tornado)
        if (code >= 701 && code <= 771) return "\uf75f";                    // smog (mist, haze, dust, ...)
        return "\uf0c2";                                               // cloud
    }

    readonly property var entries: {
        if (!current) return [{ icon: "\uf071", label: "No weather data" }];   // exclamation-triangle

        const hourly = (data.hourly ?? []).slice(0, forecastHours).map(h => h.temp);
        const high = hourly.length ? formatTemp(Math.max(...hourly)) : "–";
        const low = hourly.length ? formatTemp(Math.min(...hourly)) : "–";
        const weather = current.weather?.[0] ?? {};

        return [
            { icon: "\uf64f", label: "City",     value: city },                                                     // city
            { separator: true },
            { icon: conditionIcon(weather.id ?? -1, day), label: "Weather", value: weather.main ?? "?" },
            { separator: true },
            { icon: "\uf2c9", label: "Temp",     value: formatTemp(current.temp) },                                  // thermometer-half
            { icon: "\uf769", label: "High",     value: high, valueColor: "#d30000" },                              // temperature-high
            { icon: "\uf76b", label: "Low",      value: low, valueColor: "#0080ff" },                               // temperature-low
            { separator: true },
            { icon: "\uf043", label: "Humidity", value: `${current.humidity}%` },                                     // tint
            { separator: true },
            { icon: "\uf133", label: "Date",     value: Qt.formatDate(new Date(current.dt * 1000), "MMM-dd") },      // calendar
            { icon: "\uf062", label: "Sunrise",  value: formatTime(current.sunrise) },                              // arrow-up
            { icon: "\uf063", label: "Sunset",   value: formatTime(current.sunset) }                                // arrow-down
        ];
    }

    // fetch; the JSON is re-read once the script has exited
    Process {
        id: fetcher
        command: [Quickshell.shellDir + "/scripts/weather.sh"]
        onExited: json.reload()
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetcher.running = true
    }

    FileView {
        id: json
        path: Quickshell.shellDir + "/scripts/.weather.json"
        printErrors: false

        onLoaded: {
            try {
                root.data = JSON.parse(json.text());
            } catch (e) {
                root.data = null;
            }
        }

        onLoadFailed: root.data = null
    }

    Menu {
        id: popup
        anchorItem: root
        anchorHovered: root.hovered
        interactive: false
        entries: root.entries
    }

    onLeftClicked: popup.toggle()
}
