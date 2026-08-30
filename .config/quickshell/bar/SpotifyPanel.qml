pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs

// Panel that slides down from the spotify module: album art beside title / artist / album (the
// title wrapping to up to two lines) and the prev / play-pause / next controls, disabled when
// the player refuses the action, with a full-width elapsed / total progress bar as the
// footer, click-to-seek when the player allows it. `player` going null while open (spotify quit) closes the panel.
// Closes once the pointer has left both the module and the panel.
PopupWindow {
    id: root

    required property Item anchorItem
    property bool anchorHovered: false
    property MprisPlayer player: null
    property int textWidth: 320   // text column is fixed so the panel does not resize per track
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

    // one line of the title font, for the two-line height reservation in `artBox.side`
    TextMetrics {
        id: titleMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize + 2
        font.bold: true
        text: "Ag"
    }

    // the track's total-time string, reserving the elapsed label's width so the ticking
    // digits never shift the bar
    TextMetrics {
        id: timeMetrics
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        text: root.formatTime(root.trackLength)
    }

    // one prev / play-pause / next button
    component ControlButton: Rectangle {
        id: button

        property alias icon: buttonIcon.text
        property bool allowed: true
        property real size: root.buttonSize

        signal clicked()

        anchors.verticalCenter: parent.verticalCenter
        width: size
        height: size
        radius: size / 2
        color: allowed && buttonArea.containsMouse ? Colors.backgroundAlt : "transparent"

        Icon {
            id: buttonIcon
            anchors.centerIn: parent
            iconStyle: "solid"
            // the glyph grows with the button
            font.pixelSize: Config.iconPixelSize * button.size / root.buttonSize
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
        bottomLeftRadius: Config.panelRadius
        bottomRightRadius: Config.panelRadius
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

        ColumnLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: root.panelPadding + frame.border.width
            spacing: root.panelPadding

            RowLayout {
                spacing: root.panelPadding

                // Album art at the image's own aspect ratio, `artScale` times the info column's
                // height. The title wraps to one or two lines, so the unused line is added back
                // to keep the art — and with it the panel — the same size either way; sized off
                // implicitHeights rather than laid-out heights so the size is right on the
                // first pass. A square with the spotify glyph while there is no art or it is
                // still loading.
                ClippingRectangle {
                    id: artBox

                    readonly property bool ready: art.status === Image.Ready && art.implicitHeight > 0
                    readonly property real side: root.artScale
                        * (info.implicitHeight + (2 - titleLabel.lineCount) * titleMetrics.height)

                    Layout.preferredHeight: side
                    Layout.preferredWidth: (ready ? art.implicitWidth / art.implicitHeight : 1) * side
                    radius: Config.panelRadius
                    color: Colors.backgroundAlt
                    // dimmed while paused so the state reads at a glance
                    opacity: root.playing ? 1 : 0.5

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }

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
                    spacing: 4

                    Label {
                        id: titleLabel
                        Layout.fillWidth: true
                        font.pixelSize: Config.fontPixelSize + 2
                        font.bold: true
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
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
                        color: Colors.foregroundMuted
                        text: root.player?.trackAlbum ?? ""
                    }

                    // labels stick to the top, the controls to the bottom
                    Item { Layout.fillHeight: true }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: root.panelPadding

                        ControlButton {
                            icon: "\uf048"   // step-backward
                            allowed: root.player?.canGoPrevious ?? false
                            onClicked: root.player.previous()
                        }

                        ControlButton {
                            size: 1.5 * root.buttonSize
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

            // footer: elapsed / total around a progress bar spanning the full panel width,
            // art included; a click seeks when the player allows it; hidden when the player
            // reports no track length
            RowLayout {
                visible: root.trackLength > 0
                Layout.fillWidth: true
                spacing: Config.spaceWidth

                Label {
                    Layout.preferredWidth: timeMetrics.advanceWidth
                    horizontalAlignment: Text.AlignRight
                    color: Colors.foregroundMuted
                    text: root.formatTime(root.trackPosition)
                }

                Rectangle {
                    id: progressTrack

                    // position is writable only under both flags (see MprisPlayer docs)
                    readonly property bool seekable: (root.player?.canSeek ?? false)
                        && (root.player?.positionSupported ?? false)

                    Layout.fillWidth: true
                    Layout.preferredHeight: 2 * Config.lineSize
                    color: Colors.progressTrack

                    Rectangle {
                        height: parent.height
                        width: parent.width * (root.trackLength > 0
                            ? Math.min(1, root.trackPosition / root.trackLength) : 0)
                        color: Colors.progress
                    }

                    // the bar is only a few px tall; grow the hit area so seeking
                    // does not take pixel-perfect aim
                    MouseArea {
                        anchors.fill: parent
                        anchors.topMargin: -root.panelPadding
                        anchors.bottomMargin: -root.panelPadding
                        enabled: progressTrack.seekable
                        cursorShape: progressTrack.seekable ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: mouse =>
                            root.player.position = mouse.x / progressTrack.width * root.trackLength
                    }
                }

                Label {
                    color: Colors.foregroundMuted
                    text: root.formatTime(root.trackLength)
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
