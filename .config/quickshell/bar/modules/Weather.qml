import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.bar

// Current temperature with a condition icon. Fetches the OpenWeatherMap one-call response
// with curl every 15 min, straight into memory; a failed fetch or bad JSON keeps the last
// response, which is also cached under XDG_CACHE_HOME so a restart starts from it. Needs
// OPENWEATHERMAP_LAT / _LON / _API_KEY in the environment, otherwise the module hides.
// Left click slides open the details panel (see WeatherPanel).
Module {
    id: root

    // one-call responses carry no place name
    property string city: "Renton"
    property int forecastHours: 12   // window for the high / low
    property var data: null

    property string lat: Quickshell.env("OPENWEATHERMAP_LAT") ?? ""
    property string lon: Quickshell.env("OPENWEATHERMAP_LON") ?? ""
    property string apiKey: Quickshell.env("OPENWEATHERMAP_API_KEY") ?? ""
    readonly property bool configured: lat !== "" && lon !== "" && apiKey !== ""

    // last good response, kept across restarts so the bar is not blank while the first fetch runs
    property string cacheFile: (Quickshell.env("XDG_CACHE_HOME") ?? (Quickshell.env("HOME") + "/.cache")) + "/quickshell-weather.json"

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
        if (code === 800) return day ? "" : "";                 // sun / moon
        if (code >= 801 && code <= 804) return day ? "" : "";   // cloud-sun / cloud-moon
        if (code >= 500 && code <= 531) return "";                    // cloud-showers-heavy
        if (code >= 300 && code <= 321) return day ? "" : "";   // cloud-sun-rain / cloud-moon-rain
        if (code >= 200 && code <= 232) return "";                    // bolt
        if (code >= 600 && code <= 622) return "";                    // snowflake
        if (code === 781) return "";                                  // wind (tornado)
        if (code >= 701 && code <= 771) return "";                    // smog (mist, haze, dust, ...)
        return "";                                               // cloud
    }

    readonly property var entries: {
        if (!current) return [{ icon: "", label: "No weather data" }];   // exclamation-triangle

        const hourly = (data.hourly ?? []).slice(0, forecastHours).map(h => h.temp);
        const high = hourly.length ? formatTemp(Math.max(...hourly)) : "–";
        const low = hourly.length ? formatTemp(Math.min(...hourly)) : "–";
        const weather = current.weather?.[0] ?? {};

        return [
            { icon: "", label: "City",     value: city },                                                     // city
            { separator: true },
            { icon: conditionIcon(weather.id ?? -1, day), label: "Weather", value: weather.main ?? "?" },
            { separator: true },
            { icon: "", label: "Temp",     value: formatTemp(current.temp) },                                  // thermometer-half
            { icon: "", label: "High",     value: high, valueColor: "#d30000" },                              // temperature-high
            { icon: "", label: "Low",      value: low, valueColor: "#0080ff" },                               // temperature-low
            { separator: true },
            { icon: "", label: "Humidity", value: `${current.humidity}%` },                                     // tint
            { separator: true },
            { icon: "", label: "Date",     value: Qt.formatDate(new Date(current.dt * 1000), "MMM-dd") },      // calendar
            { icon: "", label: "Sunrise",  value: formatTime(current.sunrise) },                              // arrow-up
            { icon: "", label: "Sunset",   value: formatTime(current.sunset) }                                // arrow-down
        ];
    }

    // -f keeps HTTP errors out of stdout; the last good response stays shown either way
    Process {
        id: fetcher
        command: ["curl", "-sf", "https://api.openweathermap.org/data/3.0/onecall"
            + `?lat=${root.lat}&lon=${root.lon}&units=imperial&exclude=minutely&appid=${root.apiKey}`]

        stdout: StdioCollector { id: fetcherOut }

        onExited: exitCode => {
            if (exitCode !== 0) return;

            try {
                root.data = JSON.parse(fetcherOut.text);
                cache.setText(fetcherOut.text);
            } catch (e) {}
        }
    }

    // the .weather.json role from the script era: cache the last good response across restarts.
    // atomicWrites is the same write-through-a-temp-file trick the script used, so a crash
    // mid-write never clobbers the cache.
    FileView {
        id: cache
        path: root.cacheFile
        printErrors: false
        atomicWrites: true

        // only seed from the cache while nothing fresher has arrived
        onLoaded: {
            if (root.data !== null) return;

            try {
                root.data = JSON.parse(cache.text());
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

    WeatherPanel {
        id: panel
        anchorItem: root
        anchorHovered: root.hovered
        entries: root.entries
    }

    onLeftClicked: panel.toggle()
}
