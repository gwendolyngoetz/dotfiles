pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.notifications

// Notification daemon: a layer-shell overlay in the top-right corner of NotificationConfig.monitor,
// offset from the screen corner itself (not the bar's exclusive zone), showing the server's open
// notifications as one framed stack, critical ones first. Only one daemon can own
// org.freedesktop.Notifications, so dunst must not be running.
PanelWindow {
    id: root

    readonly property var notifications: server.trackedNotifications.values.slice()
        .sort((a, b) => b.urgency - a.urgency)

    screen: Quickshell.screens.find(s => s.name === NotificationConfig.monitor) ?? Quickshell.screens[0] ?? null

    anchors.top: true
    anchors.right: true
    margins.top: NotificationConfig.offsetY
    margins.right: NotificationConfig.offsetX
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:notifications"

    visible: root.notifications.length > 0
    color: "transparent"
    implicitWidth: NotificationConfig.width
    implicitHeight: Math.max(1, stack.implicitHeight)

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        imageSupported: true

        // untracked notifications are discarded, which is all skip_display needs
        onNotification: n => n.tracked = !NotificationConfig.style(n.appName, n.urgency).skipDisplay
    }

    Column {
        id: stack
        width: parent.width
        spacing: 0

        Repeater {
            // ScriptModel diffs by object identity, so cards survive a re-sort or a close
            model: ScriptModel { values: root.notifications }

            delegate: NotificationCard {
                required property Notification modelData
                required property int index

                notification: modelData
                first: index === 0
                last: index === root.notifications.length - 1

                onCloseAll: {
                    for (const n of server.trackedNotifications.values) n.dismiss();
                }
            }
        }
    }
}
