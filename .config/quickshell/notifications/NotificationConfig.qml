pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// How notifications look: the values from the old dunstrc under their dunst names.
Singleton {
    id: root

    readonly property string monitor: "DP-1"   // output they appear on; first screen when absent

    // geometry: top-right corner, offset 10x50 from the screen edge
    readonly property int width: 300           // frame included
    readonly property int maxHeight: 300       // of one notification, frame excluded
    readonly property int offsetX: 10
    readonly property int offsetY: 50

    // frame and spacing
    readonly property int frameWidth: 3
    readonly property color frameColor: "#aaaaaa"
    readonly property int separatorHeight: 2   // frame color showing between two notifications
    readonly property int padding: 8           // above and below the text
    readonly property int horizontalPadding: 8 // beside the text, and between icon and text

    // text
    readonly property string fontFamily: "Monospace"
    readonly property int fontPointSize: 11
    readonly property string format: "%a\n<b>%s</b>\n%b"
    readonly property int verticalAlignment: Qt.AlignVCenter   // icon against text

    // icons: scaled down to this, never up
    readonly property int maxIconSize: 64

    // progress bar, shown for the `value` hint
    readonly property int progressBarHeight: 10          // frame included
    readonly property int progressBarFrameWidth: 1
    readonly property int progressBarMinWidth: 150
    readonly property int progressBarMaxWidth: 300
    readonly property color highlight: "#7f7fff"         // the done part; dunst's default

    // [urgency_low] / [urgency_normal] / [urgency_critical], indexed by NotificationUrgency;
    // timeout in seconds, 0 never
    readonly property var urgencies: [
        { background: "#222222", foreground: "#888888", frameColor: root.frameColor, timeout: 10 },
        { background: "#285577", foreground: "#ffffff", frameColor: root.frameColor, timeout: 10 },
        { background: "#900000", foreground: "#ffffff", frameColor: "#ff0000", timeout: 0 },
    ]

    // per-app overrides, applied in order on top of the urgency section; `urgency` narrows a
    // rule to one level. Any field of the style can be overridden, plus `newIcon` (replaces
    // the icon) and `skipDisplay` (never shown).
    readonly property var rules: [
        { appName: "Solaar", skipDisplay: true },
        { appName: "Slack", background: "#4a154b" },
    ]

    // the style for one notification: defaults, its urgency section, then the matching rules
    function style(appName, urgency) {
        const level = Math.max(0, Math.min(root.urgencies.length - 1, urgency));
        const s = Object.assign({
            format: root.format,
            maxIconSize: root.maxIconSize,
            verticalAlignment: root.verticalAlignment,
            newIcon: "",
            skipDisplay: false,
        }, root.urgencies[level]);

        for (const rule of root.rules) {
            if (rule.appName !== appName) continue;
            if (rule.urgency !== undefined && rule.urgency !== level) continue;

            Object.assign(s, rule);
        }

        return s;
    }
}
