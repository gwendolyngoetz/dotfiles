pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property color base00: "#282936"   // background
    readonly property color base03: "#626483"   // comments, muted
    readonly property color base05: "#e9e9f4"   // foreground
    readonly property color base07: "#f7f7fb"   // bright foreground
    readonly property color base08: "#ea51b2"   // red / alert
    readonly property color base0A: "#00f769"   // yellow slot, green here
    readonly property color base0E: "#5a4799"   // purple / accent

    // bar
    readonly property color background:    base00
    readonly property color backgroundAlt: "#3a3b4d"   // base00 lightened, keeping its blue cast
    readonly property color foreground:    base05
    readonly property color foregroundAlt: "#515370"   // dim glyphs, between base00 and base03
    readonly property color foregroundMuted: "#9a9cbf"   // base03 lightened until readable on base00
    readonly property color primary:       base0E
    readonly property color alert:         base08
    readonly property color spotify:       base0A
    readonly property color progress:      "#7aa2f7"   // elapsed part of progress bars
    readonly property color progressTrack: base03   // remaining part, visible against base00
    readonly property color borderPrimary: base0E

    // tray bar background
    readonly property color trayBarBackground: "#000000"

    // Launcher. The alpha only shows through with a compositor running; use base00 directly if
    // the launcher background renders black.
    readonly property color launcherBg:     Qt.rgba(base00.r, base00.g, base00.b, 0.8)
    readonly property color launcherFg:     base07
    readonly property color launcherAlt:    base03
    readonly property color launcherAccent: base0E
}
