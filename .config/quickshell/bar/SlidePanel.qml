pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs

// Chrome shared by every panel that slides down from a bar module: the anchored PopupWindow,
// the bordered frame with rounded bottom corners, the slide in/out animation, and closing
// once the pointer has left both the module and the panel (with a small grace period).
// Content goes in the default slot, inset by `padding`; the frame takes the content's
// implicit size, at least `minWidth` wide. `aboutToShow()` fires before each open for
// per-open prep; `closeFinished()` fires once the close slide has ended. A panel may
// declare an `ambient` layer — atmosphere drawn behind the content (blurred album art, a
// weather tint); it is clipped to the frame and covered by a scrim that keeps the top edge
// exactly the bar background (no seam while sliding) and fades to `scrim` coverage below,
// so the content keeps its contrast. Without an ambient, the frame stays flat.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property int padding: 0   // content inset inside the frame border
    property int minWidth: 0
    // how much background covers the ambient below the seam: 1 hides it, 0 is raw
    property real scrim: 0.8

    property bool open: false

    default property alias content: slot.data
    // optional atmosphere behind the content; see the header comment
    property alias ambient: ambientSlot.data

    signal aboutToShow()
    signal closeFinished()

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right

    visible: false
    color: "transparent"
    implicitWidth: frame.implicitWidth
    implicitHeight: frame.implicitHeight

    function show() {
        root.aboutToShow();

        // the module drifts as modules left of it change width; re-anchor before each show
        root.anchor.updateAnchor();
        root.visible = true;
        root.open = true;
    }

    function hide() {
        root.open = false;
    }

    function toggle() {
        if (root.open) hide(); else show();
    }

    onAnchorHoveredChanged: if (open) closeTimer.restart()

    Rectangle {
        id: frame
        width: parent.width
        height: parent.height
        // slides down out of the bar; while closed it sits above the (clipped) window
        y: root.open ? 0 : -height
        color: Colors.background
        border.width: 1
        border.color: Colors.borderPrimary
        bottomLeftRadius: Config.panelRadius
        bottomRightRadius: Config.panelRadius
        implicitWidth: Math.max(root.minWidth,
            slot.implicitWidth + 2 * (root.padding + border.width))
        implicitHeight: slot.implicitHeight + 2 * (root.padding + border.width)

        Behavior on y {
            enabled: root.visible

            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
                onRunningChanged: {
                    if (running || root.open) return;

                    root.visible = false;
                    root.closeFinished();
                }
            }
        }

        HoverHandler {
            id: hover
            onHoveredChanged: if (root.open) closeTimer.restart()
        }

        // ambient layer, only rendered when a panel declares one
        ClippingRectangle {
            visible: ambientSlot.children.length > 0
            anchors.fill: parent
            anchors.margins: frame.border.width
            radius: Config.panelRadius
            color: "transparent"

            Item {
                id: ambientSlot
                anchors.fill: parent
            }

            // the seam-safe scrim over the ambient
            Rectangle {
                id: scrimRect

                readonly property color veil: Qt.rgba(Colors.background.r,
                    Colors.background.g, Colors.background.b, root.scrim)

                anchors.fill: parent

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Colors.background }
                    GradientStop { position: 0.35; color: scrimRect.veil }
                    GradientStop { position: 1.0; color: scrimRect.veil }
                }
            }
        }

        // content parent; sized to the single content item's implicit size
        Item {
            id: slot
            anchors.fill: parent
            anchors.margins: root.padding + frame.border.width
            implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
            implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
        }
    }

    // small grace period so moving from the module down into the panel does not close it
    Timer {
        id: closeTimer
        interval: 400
        onTriggered: if (!hover.hovered && !root.anchorHovered) root.hide()
    }
}
