pragma Singleton
import QtQuick
import Quickshell

// [colors] from polybar/config.ini and the "*" block of rofi/config.rasi.
// polybar colors are AARRGGBB, same as Qt. rofi's #RRGGBBAA is converted below.
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

    // [bar/secondary] background
    readonly property color trayBarBackground: "#000000"

    // rofi: color-bg #282936CC, color-fg, color-alt, color-pri.
    // Alpha only shows through with a compositor running; i3 config has compton commented out,
    // so drop the CC prefix if the launcher background renders black.
    readonly property color rofiBg:  "#CC282936"
    readonly property color rofiFg:  "#f7f7fb"
    readonly property color rofiAlt: "#626483"
    readonly property color rofiPri: "#5a4799"
}
