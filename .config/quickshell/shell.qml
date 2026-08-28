import QtQuick
import Quickshell
import qs
import qs.bar
import qs.launcher

// Quickshell port of ~/.config/polybar (bars.ini / modules.ini) and ~/.config/rofi/config.rasi.
// The originals are untouched; swap back by reverting the two lines in ~/.config/i3/config.
ShellRoot {
    // [bar/main]: one per connected monitor (launch.sh looped over xrandr outputs)
    Variants {
        model: Quickshell.screens

        delegate: Bar {
            required property var modelData
            screen: modelData
        }
    }

    // [bar/secondary]: tray bar on the primary monitor only
    Variants {
        model: Quickshell.screens.filter(s => s.name === Env.primaryMonitor)

        delegate: TrayBar {
            required property var modelData
            screen: modelData
        }
    }

    Launcher {}
}
