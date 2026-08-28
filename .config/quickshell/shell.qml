pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs
import qs.bar
import qs.launcher

// Top bar on every monitor, tray bar on the primary one, and the app launcher.
ShellRoot {
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
        model: Quickshell.screens.filter(s => s.name === Env.primaryMonitor)

        delegate: TrayBar {
            required property ShellScreen modelData
            screen: modelData
        }
    }

    Launcher {}
}
