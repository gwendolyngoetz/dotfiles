pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Bar geometry, fonts and spacing.
Singleton {
    id: root

    // xrdb -query, keyed without the leading "*" (color0, Xft.dpi, ...); Colors.qml reads color*
    property var xrdb: ({})

    readonly property int barHeight: 30
    readonly property int trayBarHeight: 20
    readonly property int lineSize: 2
    // extra strut reserved beyond the bar
    readonly property int wmMargin: 5

    property string fontFamily: "Noto Sans"
    property int fontPixelSize: 15
    property string iconFontFamily: "Font Awesome 5 Free"
    property int iconPixelSize: 17
    property string brandsFontFamily: "Font Awesome 5 Brands"
    property int brandsPixelSize: 17

    // padding and margin units are spaces of the bar font
    readonly property real spaceWidth: spaceMetrics.advanceWidth + .2
    readonly property int paddingLeft: 0
    readonly property int paddingRight: 2
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
            id: xrdbOut

            onStreamFinished: {
                const map = {};

                for (const line of xrdbOut.text.split("\n")) {
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
