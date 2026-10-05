import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.notifications

// One notification, drawn the way dunst draws a stack with gap_size 0: the frame runs down both
// sides, closes the stack at the top and bottom, and shows through between two notifications as
// the separator. Icon on the left, the formatted text beside it, the progress bar underneath
// when the notification carries a `value` hint. Expires itself after the urgency's timeout.
// Left click dismisses, middle click fires the default action and dismisses, right click
// dismisses everything.
Rectangle {
    id: root

    required property Notification notification
    required property bool first
    required property bool last

    signal closeAll()

    readonly property var style: NotificationConfig.style(notification.appName, notification.urgency)
    // the `value` hint, or -1
    readonly property int progress: notification.hints?.value ?? -1
    // seconds; the client's when it set one, else the urgency's; 0 never
    readonly property real timeout: notification.expireTimeout >= 0 ? notification.expireTimeout : style.timeout

    // a rule's icon beats the notification's image, which beats its app icon
    readonly property string iconSource: {
        if (root.style.newIcon !== "") return root.style.newIcon;
        if (root.notification.image !== "") return root.notification.image;
        if (root.notification.appIcon !== "") return Quickshell.iconPath(root.notification.appIcon, true);
        return "";
    }

    // the format with %a (escaped), %s and %b (markup kept) filled in; a trailing newline from
    // an empty body is dropped
    readonly property string text: {
        const n = root.notification;
        const appName = n.appName.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

        return root.style.format
            .replace(/%([asb%])/g, (m, c) => c === "a" ? appName : c === "s" ? n.summary : c === "b" ? n.body : "%")
            .replace(/\s+$/, "")
            .replace(/\n/g, "<br>");
    }

    implicitWidth: NotificationConfig.width
    implicitHeight: body.implicitHeight + body.anchors.topMargin + body.anchors.bottomMargin
    color: root.style.frameColor

    Rectangle {
        id: body

        anchors.fill: parent
        anchors.leftMargin: NotificationConfig.frameWidth
        anchors.rightMargin: NotificationConfig.frameWidth
        anchors.topMargin: root.first ? NotificationConfig.frameWidth : 0
        anchors.bottomMargin: root.last ? NotificationConfig.frameWidth : NotificationConfig.separatorHeight
        color: root.style.background
        implicitHeight: Math.min(NotificationConfig.maxHeight, column.implicitHeight + 2 * NotificationConfig.padding)
        clip: true

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: NotificationConfig.horizontalPadding
            anchors.rightMargin: NotificationConfig.horizontalPadding
            anchors.topMargin: NotificationConfig.padding
            spacing: NotificationConfig.padding

            // icon and text, aligned against each other per vertical_alignment
            Item {
                width: parent.width
                implicitHeight: Math.max(icon.visible ? icon.height : 0, label.implicitHeight)

                Image {
                    id: icon
                    anchors.left: parent.left
                    anchors.top: root.style.verticalAlignment === Qt.AlignTop ? parent.top : undefined
                    anchors.verticalCenter: root.style.verticalAlignment === Qt.AlignVCenter ? parent.verticalCenter : undefined
                    visible: status === Image.Ready
                    source: root.iconSource
                    // raster icons are scaled down to fit and never up; vectors render at this size
                    sourceSize: Qt.size(root.style.maxIconSize, root.style.maxIconSize)
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: label
                    anchors.left: icon.visible ? icon.right : parent.left
                    anchors.leftMargin: icon.visible ? NotificationConfig.horizontalPadding : 0
                    anchors.right: parent.right
                    anchors.top: root.style.verticalAlignment === Qt.AlignTop ? parent.top : undefined
                    anchors.verticalCenter: root.style.verticalAlignment === Qt.AlignVCenter ? parent.verticalCenter : undefined
                    text: root.text
                    textFormat: Text.StyledText
                    font.family: NotificationConfig.fontFamily
                    font.pointSize: NotificationConfig.fontPointSize
                    color: root.style.foreground
                    linkColor: root.style.foreground
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: Math.max(1, Math.floor(
                        (NotificationConfig.maxHeight - 2 * NotificationConfig.padding) / metrics.lineSpacing))
                }
            }

            // progress bar: frame in the frame color, the done part highlighted, the rest background
            Rectangle {
                visible: root.progress >= 0
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(NotificationConfig.progressBarMaxWidth,
                    Math.max(NotificationConfig.progressBarMinWidth, parent.width))
                height: NotificationConfig.progressBarHeight
                color: root.style.frameColor

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: NotificationConfig.progressBarFrameWidth
                    color: root.style.background

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.min(100, Math.max(0, root.progress)) / 100
                        color: NotificationConfig.highlight
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onClicked: mouse => {
                if (mouse.button === Qt.RightButton) {
                    root.closeAll();
                    return;
                }

                if (mouse.button === Qt.MiddleButton) {
                    const actions = root.notification.actions;
                    (actions.find(a => a.identifier === "default") ?? (actions.length === 1 ? actions[0] : null))?.invoke();
                }

                root.notification.dismiss();
            }
        }
    }

    Timer {
        interval: root.timeout * 1000
        running: root.timeout > 0
        onTriggered: root.notification.expire()
    }

    FontMetrics {
        id: metrics
        font.family: NotificationConfig.fontFamily
        font.pointSize: NotificationConfig.fontPointSize
    }
}
