pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs

// Panel that slides down from the spotify module: album art spanning the full panel height,
// title / artist / album and the prev / play-pause / next controls, disabled when the player
// refuses the action. `player` going null while open (spotify quit) closes the panel.
// Closes once the pointer has left both the module and the panel.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property MprisPlayer player: null
    property int textWidth: 220   // text column is fixed so the panel does not resize per track
    property int panelPadding: 10
    property int buttonSize: 36

    property bool open: false

    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right

    visible: false
    color: "transparent"
    implicitWidth: frame.implicitWidth
    implicitHeight: frame.implicitHeight

    function show() {
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

    // spotify quit while the panel was open
    onPlayerChanged: if (player === null) hide()

    // one prev / play-pause / next button
    component ControlButton: Rectangle {
        id: button

        property alias icon: buttonIcon.text
        property bool allowed: true

        signal clicked()

        width: root.buttonSize
        height: root.buttonSize
        radius: root.buttonSize / 2
        color: allowed && buttonArea.containsMouse ? Colors.backgroundAlt : "transparent"

        Icon {
            id: buttonIcon
            anchors.centerIn: parent
            iconStyle: "solid"
            color: button.allowed ? Colors.foreground : Colors.foregroundAlt
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            enabled: button.allowed
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    Rectangle {
        id: frame
        width: parent.width
        height: parent.height
        // slides down out of the bar; while closed it sits above the (clipped) window
        y: root.open ? 0 : -height
        color: Colors.background
        border.width: 1
        border.color: Colors.borderPrimary
        implicitWidth: layout.implicitWidth + 2 * (root.panelPadding + border.width)
        implicitHeight: layout.implicitHeight + 2 * (root.panelPadding + border.width)

        Behavior on y {
            enabled: root.visible

            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
                onRunningChanged: if (!running && !root.open) root.visible = false
            }
        }

        HoverHandler {
            id: hover
            onHoveredChanged: if (root.open) closeTimer.restart()
        }

        RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: root.panelPadding + frame.border.width
            spacing: root.panelPadding

            // Album art spanning the full content height, at the image's own aspect ratio.
            // Sized off the info column's implicitHeight rather than the laid-out height so the
            // width is right on the first pass; a square with the spotify glyph while there is
            // no art or it is still loading.
            Rectangle {
                id: artBox

                readonly property bool ready: art.status === Image.Ready && art.implicitHeight > 0

                Layout.fillHeight: true
                Layout.preferredWidth: (ready ? art.implicitWidth / art.implicitHeight : 1) * info.implicitHeight
                color: Colors.backgroundAlt

                Image {
                    id: art
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    source: root.player?.trackArtUrl ?? ""
                }

                Icon {
                    anchors.centerIn: parent
                    visible: !artBox.ready
                    iconStyle: "brands"
                    text: "\uf1bc"   // spotify
                    color: Colors.spotify
                }
            }

            ColumnLayout {
                id: info
                Layout.preferredWidth: root.textWidth
                Layout.maximumWidth: root.textWidth
                spacing: 2

                Label {
                    Layout.fillWidth: true
                    font.bold: true
                    elide: Text.ElideRight
                    text: root.player?.trackTitle ?? ""
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: root.player?.trackArtist ?? ""
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    color: Colors.foregroundAlt
                    text: root.player?.trackAlbum ?? ""
                }

                Row {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: root.panelPadding
                    spacing: root.panelPadding

                    ControlButton {
                        icon: "\uf048"   // step-backward
                        allowed: root.player?.canGoPrevious ?? false
                        onClicked: root.player.previous()
                    }

                    ControlButton {
                        icon: root.playing ? "\uf04c" : "\uf04b"   // pause / play
                        allowed: root.player?.canTogglePlaying ?? false
                        onClicked: root.player.togglePlaying()
                    }

                    ControlButton {
                        icon: "\uf051"   // step-forward
                        allowed: root.player?.canGoNext ?? false
                        onClicked: root.player.next()
                    }
                }
            }
        }
    }

    // small grace period so moving from the module down into the panel does not close it
    Timer {
        id: closeTimer
        interval: 400
        onTriggered: if (!hover.hovered && !root.anchorHovered) root.hide()
    }
}
