import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.bar

// scripts/weather.sh every 15 min. It writes the OpenWeatherMap one-call response to
// scripts/.weather.json and prints the bar label; left click opens a popup with the details.
ScriptModule {
    id: root

    // one-call responses carry no place name
    property string city: "Renton"
    property int forecastHours: 12   // window for the high / low
    property var data: null

    exec: Quickshell.shellDir + "/scripts/weather.sh"
    interval: 900000
    prefix: ""
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
        if (code === 800) return day ? "" : "";                 // sun / moon
        if (code >= 801 && code <= 804) return day ? "" : "";   // cloud-sun / cloud-moon
        if (code >= 500 && code <= 531) return "";                    // cloud-showers-heavy
        if (code >= 300 && code <= 321) return day ? "" : "";   // cloud-sun-rain / cloud-moon-rain
        if (code >= 200 && code <= 232) return "";                    // bolt
        if (code >= 600 && code <= 622) return "";                    // snowflake
        if (code === 781) return "";                                  // wind (tornado)
        if (code >= 701 && code <= 771) return "";                    // smog (mist, haze, dust, ...)
        return "";                                                    // cloud
    }

    readonly property var entries: {
        if (!data) return [{ icon: "", label: "No weather data" }];   // exclamation-triangle

        const current = data.current;
        const hourly = (data.hourly ?? []).slice(0, forecastHours).map(h => h.temp);
        const day = current.dt >= current.sunrise && current.dt <= current.sunset;

        return [
            { icon: "", label: "City",     value: city },                                                     // city
            { separator: true },
            { icon: conditionIcon(current.weather[0].id, day), label: "Weather", value: current.weather[0].main },
            { separator: true },
            { icon: "", label: "Temp",     value: formatTemp(current.temp) },                                  // thermometer-half
            { icon: "", label: "High",     value: formatTemp(Math.max(...hourly)), valueColor: "#d30000" },    // temperature-high
            { icon: "", label: "Low",      value: formatTemp(Math.min(...hourly)), valueColor: "#0080ff" },    // temperature-low
            { separator: true },
            { icon: "", label: "Humidity", value: `${current.humidity}%` },                                     // tint
            { separator: true },
            { icon: "", label: "Date",     value: Qt.formatDate(new Date(current.dt * 1000), "MMM-dd") },      // calendar
            { icon: "", label: "Sunrise",  value: formatTime(current.sunrise) },                              // arrow-up
            { icon: "", label: "Sunset",   value: formatTime(current.sunset) }                                // arrow-down
        ];
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

        // re-read the file on open; weather.sh rewrites it before every label update
        onVisibleChanged: if (visible) json.reload()
    }

    onLeftClicked: popup.toggle()
}
