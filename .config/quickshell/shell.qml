pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar
import qs.launcher

// Top bar on every monitor, tray bar on the primary one, and the app launcher.
ShellRoot {
    id: root

    // Screen carrying the tray bar. MONITOR in the environment wins; otherwise the primary
    // output is asked of the display server, falling back to the first screen.
    property string primaryMonitor: Quickshell.env("MONITOR") ?? ""

    Process {
        running: root.primaryMonitor === ""
        command: ["bash", "-c", Quickshell.env("WAYLAND_DISPLAY")
            ? `swaymsg -t get_outputs 2>/dev/null | jq -r 'first(.[] | select(.focused) | .name) // empty'`
            : `xrandr --query | grep -E 'connected primary [0-9]' | cut -d' ' -f1 | head -n1`]

        stdout: StdioCollector {
            id: detected

            onStreamFinished: {
                const name = detected.text.trim();
                root.primaryMonitor = name !== "" ? name : (Quickshell.screens[0]?.name ?? "");
            }
        }
    }

    // one bar per connected monitor
    Variants {
        model: Quickshell.screens

        delegate: Bar {
            required property ShellScreen modelData
            screen: modelData
        }
    }

    // tray bar on the primary monitor only
    Variants {
        model: Quickshell.screens.filter(s => s.name === root.primaryMonitor)

        delegate: TrayBar {
            required property ShellScreen modelData
            screen: modelData
        }
    }

    Launcher {}
}
