pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs

// Chrome shared by every panel that slides down from a bar module: the anchored PopupWindow,
// the bordered frame with rounded bottom corners, the slide in/out animation, and closing
// once the pointer has left both the module and the panel (with a small grace period).
// Content goes in the default slot, inset by `padding`; the frame takes the content's
// implicit size, at least `minWidth` wide. `aboutToShow()` fires before each open for
// per-open prep; `closeFinished()` fires once the close slide has ended.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property int padding: 0   // content inset inside the frame border
    property int minWidth: 0

    property bool open: false

    default property alias content: slot.data

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
