pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// The environment polybar/launch.sh exported (ETHERNET_INT, WIFI_INT, TEMPERATURE_PATH) plus
// the xrandr primary-output lookup. Existing env vars win so the old launcher's exports still apply.
Singleton {
    id: root

    property string ethernetInterface: Quickshell.env("ETHERNET_INT") ?? ""
    property string wifiInterface: Quickshell.env("WIFI_INT") ?? ""
    property string temperaturePath: Quickshell.env("TEMPERATURE_PATH") ?? ""
    property string primaryMonitor: Quickshell.env("MONITOR") ?? ""

    Process {
        running: true
        command: ["bash", "-c", `
            echo "ETHERNET_INT=\${ETHERNET_INT:-$(ip -o link show | grep "state UP" | cut -d' ' -f2 | cut -d':' -f1 | head -n1)}"
            echo "WIFI_INT=\${WIFI_INT:-$(ls --ignore lo --ignore 'e*' --ignore 'docker*' /sys/class/net 2>/dev/null | head -n1)}"
            if [ -z "$TEMPERATURE_PATH" ]; then
                dir=$(find /sys/class/hwmon/* -maxdepth 1 -exec grep -rw --include=name "{}/" -l -e "k10temp" \; 2>/dev/null | head -n1 | xargs -r dirname)
                [ -n "$dir" ] && TEMPERATURE_PATH="$dir/temp1_input"
            fi
            echo "TEMPERATURE_PATH=$TEMPERATURE_PATH"
            echo "PRIMARY_MONITOR=$(xrandr --query | grep -E 'connected primary [0-9]' | cut -d' ' -f1 | head -n1)"
        `]

        stdout: StdioCollector {
            onStreamFinished: {
                for (const line of this.text.split("\n")) {
                    const idx = line.indexOf("=");
                    if (idx < 0) continue;

                    const key = line.slice(0, idx);
                    const value = line.slice(idx + 1).trim();

                    if (key === "ETHERNET_INT") root.ethernetInterface = value;
                    else if (key === "WIFI_INT") root.wifiInterface = value;
                    else if (key === "TEMPERATURE_PATH") root.temperaturePath = value;
                    else if (key === "PRIMARY_MONITOR" && value !== "") root.primaryMonitor = value;
                }

                if (root.primaryMonitor === "" && Quickshell.screens.length > 0)
                    root.primaryMonitor = Quickshell.screens[0].name;
            }
        }
    }
}
