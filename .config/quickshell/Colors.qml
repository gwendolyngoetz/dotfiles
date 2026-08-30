pragma Singleton
import QtQuick
import Quickshell

// Bar and launcher palette. Bar colors come from xrdb where set.
Singleton {
    readonly property color background:    Config.xrdb["color0"]  ?? "#dd222222"
    readonly property color backgroundAlt: "#444"
    readonly property color foreground:    Config.xrdb["color7"]  ?? "#dfdfdf"
    readonly property color foregroundAlt: "#555"
    readonly property color primary:       Config.xrdb["color13"] ?? "#9f78e1"
    readonly property color secondary:     "#e60053"
    readonly property color alert:         Config.xrdb["color1"]  ?? "#bd2c40"
    readonly property color spotify:       Config.xrdb["color3"]  ?? "#00ff00"
    readonly property color borderPrimary: Config.xrdb["color13"] ?? "#9f78e1"

    // tray bar background
    readonly property color trayBarBackground: "#000000"

    // Launcher. The alpha only shows through with a compositor running; drop the CC prefix if
    // the launcher background renders black.
    readonly property color launcherBg:     "#CC282936"
    readonly property color launcherFg:     "#f7f7fb"
    readonly property color launcherAlt:    "#626483"
    readonly property color launcherAccent: "#5a4799"
}
