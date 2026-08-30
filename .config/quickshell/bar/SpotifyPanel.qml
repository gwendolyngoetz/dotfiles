pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs

// Panel that slides down from the spotify module: album art spanning the full panel height,
// title / artist / album, a read-only elapsed / total progress bar and the prev / play-pause /
// next controls, disabled when the player refuses the action. `player` going null while open
// (spotify quit) closes the panel. Closes once the pointer has left both the module and the panel.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property MprisPlayer player: null
    property int textWidth: 220   // text column is fixed so the panel does not resize per track
    property real artScale: 1.5   // art height relative to the info column's height
    property int panelPadding: 10
    property int buttonSize: 36

    property bool open: false

    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing
    readonly property real trackLength: player?.length ?? 0
    readonly property real trackPosition: player?.position ?? 0

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

    // 83 -> "1:23", 3753 -> "1:02:33"
    function formatTime(s) {
        const t = Math.max(0, Math.round(s));
        const h = Math.floor(t / 3600), m = Math.floor(t / 60) % 60, sec = t % 60;

        const ss = String(sec).padStart(2, "0");
        return h > 0 ? `${h}:${String(m).padStart(2, "0")}:${ss}` : `${m}:${ss}`;
    }

    onAnchorHoveredChanged: if (open) closeTimer.restart()

    // spotify quit while the panel was open
    onPlayerChanged: if (player === null) hide()

    // quickshell recomputes `position` only when the player reports a change; nudge it every
    // second while the panel is open so the progress bar advances
    Timer {
        interval: 1000
        running: root.visible && root.player !== null
        repeat: true
        triggeredOnStart: true
        onTriggered: root.player.positionChanged()
    }

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

            // Album art at the image's own aspect ratio, `artScale` times the info column's
            // height; the panel height follows it and the info column centers beside it. Sized
            // off implicitHeight rather than the laid-out height so the size is right on the
            // first pass; a square with the spotify glyph while there is no art or it is
            // still loading.
            Rectangle {
                id: artBox

                readonly property bool ready: art.status === Image.Ready && art.implicitHeight > 0
                readonly property real side: root.artScale * info.implicitHeight

                Layout.preferredHeight: side
                Layout.preferredWidth: (ready ? art.implicitWidth / art.implicitHeight : 1) * side
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
                Layout.fillHeight: true
                Layout.preferredWidth: root.textWidth
                Layout.maximumWidth: root.textWidth
                spacing: 2

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: Config.fontPixelSize + 2
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

                // labels stick to the top, the progress bar and controls to the bottom
                Item { Layout.fillHeight: true }

                // elapsed / total around a read-only progress bar; hidden when the player
                // reports no track length
                RowLayout {
                    visible: root.trackLength > 0
                    Layout.fillWidth: true
                    Layout.topMargin: root.panelPadding
                    spacing: Config.spaceWidth

                    Label {
                        color: Colors.foregroundAlt
                        text: root.formatTime(root.trackPosition)
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 2 * Config.lineSize
                        color: Colors.backgroundAlt

                        Rectangle {
                            height: parent.height
                            width: parent.width * (root.trackLength > 0
                                ? Math.min(1, root.trackPosition / root.trackLength) : 0)
                            color: Colors.borderPrimary
                        }
                    }

                    Label {
                        color: Colors.foregroundAlt
                        text: root.formatTime(root.trackLength)
                    }
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
