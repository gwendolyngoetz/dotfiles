pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Mirrors [bar/base] in bars.ini and [variables] in config.ini.
Singleton {
    id: root

    // xrdb -query, keyed without the leading "*" (color0, Xft.dpi, polybar.height, ...)
    property var xrdb: ({})

    // height = ${xrdb:polybar.height:30}
    readonly property int barHeight: parseInt(xrdb["polybar.height"] ?? "30")
    readonly property int trayBarHeight: 20
    readonly property int lineSize: 2
    // [global/wm] margin-top / margin-bottom: extra strut reserved beyond the bar
    readonly property int wmMargin: 5

    // polybar used font-0 = fixed:pixelsize=12, but fontconfig on this machine aliases "fixed"
    // to Noto Sans (fc-match -v "fixed:pixelsize=12"), so that is what polybar actually drew.
    property string fontFamily: "Noto Sans"
    property int fontPixelSize: 15
    // font-2/3 = Font Awesome 5 Free Regular/Solid pixelsize=13, font-4 = Brands pixelsize=12
    property string iconFontFamily: "Font Awesome 5 Free"
    property int iconPixelSize: 17
    property string brandsFontFamily: "Font Awesome 5 Brands"
    property int brandsPixelSize: 17

    // polybar padding/margin units are "spaces" of font-0
    readonly property real spaceWidth: spaceMetrics.advanceWidth + .2
    readonly property int paddingLeft: 0
    readonly property int paddingRight: 2   // polybar had 2; bar now ends flush right
    readonly property int moduleMarginLeft: 1
    readonly property int moduleMarginRight: 2
    readonly property int i3Padding: 3
    readonly property int trayPadding: 2
    readonly property int trayIconSize: 16

    TextMetrics {
        id: spaceMetrics
        font.family: root.fontFamily
        font.pixelSize: root.fontPixelSize
        text: " "
    }

    Process {
        command: ["xrdb", "-query"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const map = {};

                for (const line of this.text.split("\n")) {
                    const idx = line.indexOf(":");
                    if (idx < 0) continue;

                    const key = line.slice(0, idx).trim().replace(/^\*\.?/, "");
                    map[key] = line.slice(idx + 1).trim();
                }

                root.xrdb = map;
            }
        }
    }
}
