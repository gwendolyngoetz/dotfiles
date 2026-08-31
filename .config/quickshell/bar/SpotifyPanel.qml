pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs

// Panel that slides down from the spotify module: album art beside title / artist / album (the
// title wrapping to up to two lines) and the prev / play-pause / next controls, disabled when
// the player refuses the action, with a full-width elapsed / total progress bar as the
// footer. When the player allows seeking, the bar thickens on hover into a scrubber with a
// playhead knob and a cursor-time readout; click or drag seeks. Track changes crossfade the
// album art and fade the new text in. `player` going null while open (spotify quit) closes
// the panel. The window chrome — frame, slide animation, hover-close — lives in SlidePanel.
SlidePanel {
    id: root

    property MprisPlayer player: null
    property int textWidth: 320   // text column is fixed so the panel does not resize per track
    property real artScale: 1.25   // art height relative to the info column's height
    property int buttonSize: 36

    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing
    readonly property real trackLength: player?.length ?? 0
    readonly property real trackPosition: player?.position ?? 0
    // one string that changes exactly when the displayed track does
    readonly property string trackKey: [player?.trackTitle, player?.trackArtist,
        player?.trackAlbum].join("\n")

    padding: 10

    // 83 -> "1:23", 3753 -> "1:02:33"
    function formatTime(s) {
        const t = Math.max(0, Math.round(s));
        const h = Math.floor(t / 3600), m = Math.floor(t / 60) % 60, sec = t % 60;

        const ss = String(sec).padStart(2, "0");
        return h > 0 ? `${h}:${String(m).padStart(2, "0")}:${ss}` : `${m}:${ss}`;
    }

    // spotify quit while the panel was open
    onPlayerChanged: if (player === null) hide()

    // the art crossfades on its own (see artBox); this brings the new text in with it
    onTrackKeyChanged: if (visible) trackIntro.restart()

    // quickshell recomputes `position` only when the player reports a change; nudge it every
    // second while the panel is open so the progress bar advances
    Timer {
        interval: 1000
        running: root.visible && root.player !== null
        repeat: true
        triggeredOnStart: true
        onTriggered: root.player.positionChanged()
    }

    // the new track's text snaps hidden, then fades in with a slight rise
    SequentialAnimation {
        id: trackIntro

        PropertyAction { target: info; property: "textOpacity"; value: 0 }
        PropertyAction { target: info; property: "textShift"; value: 6 }

        ParallelAnimation {
            NumberAnimation {
                target: info
                property: "textOpacity"
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: info
                property: "textShift"
                to: 0
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
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
            // the play <-> pause swap lands with a little tick instead of teleporting
            onTextChanged: glyphTick.restart()

            SequentialAnimation {
                id: glyphTick

                NumberAnimation { target: buttonIcon; property: "scale"; to: 0.8; duration: 60 }

                NumberAnimation {
                    target: buttonIcon
                    property: "scale"
                    to: 1
                    duration: 120
                    easing.type: Easing.OutBack
                }
            }
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

    // one of the two stacked cover images in artBox: the front one is visible, the back one
    // preloads the incoming cover and crossfades in once it is ready
    component ArtImage: Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        opacity: artBox.front === img ? 1 : 0
        onStatusChanged: if (artBox.back === img && status === Image.Ready) artBox.swapArt()

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: root.padding

        RowLayout {
            spacing: root.padding

            // Album art at the image's own aspect ratio, `artScale` times the info column's
            // height. The title wraps to one or two lines, so the unused line is added back
            // to keep the art — and with it the panel — the same size either way; sized off
            // implicitHeights rather than laid-out heights so the size is right on the
            // first pass. A square with the spotify glyph while there is no art or it is
            // still loading. Track changes preload the new cover into the hidden back
            // image and crossfade the pair once it is ready.
            ClippingRectangle {
                id: artBox

                property Image front: artA
                property Image back: artB
                readonly property string artUrl: root.player?.trackArtUrl ?? ""
                readonly property bool ready: front.status === Image.Ready && front.implicitHeight > 0
                readonly property real side: root.artScale
                    * (info.implicitHeight + (2 - titleLabel.lineCount) * titleMetrics.height)

                function swapArt() {
                    const shown = front;
                    front = back;
                    back = shown;
                }

                onArtUrlChanged: {
                    if (artUrl === "") {
                        // nothing to load; fade straight to the placeholder
                        back.source = "";
                        swapArt();
                    } else if (String(back.source) === artUrl && back.status === Image.Ready) {
                        // the outgoing cover is being brought back (e.g. prev after next)
                        swapArt();
                    } else {
                        back.source = artUrl;
                    }
                }

                Component.onCompleted: back.source = artUrl

                Layout.preferredHeight: side
                Layout.preferredWidth: (ready ? front.implicitWidth / front.implicitHeight : 1) * side
                radius: Config.panelRadius
                color: Colors.backgroundAlt
                // dimmed while paused so the state reads at a glance
                opacity: root.playing ? 1 : 0.5

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }

                ArtImage { id: artA }
                ArtImage { id: artB }

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

                // driven by trackIntro on track change; the labels share both values
                property real textOpacity: 1
                property real textShift: 0

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
                    opacity: info.textOpacity
                    transform: Translate { y: info.textShift }
                    text: root.player?.trackTitle ?? ""
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    opacity: info.textOpacity
                    transform: Translate { y: info.textShift }
                    text: root.player?.trackArtist ?? ""
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    opacity: info.textOpacity
                    transform: Translate { y: info.textShift }
                    color: Colors.foregroundMuted
                    text: root.player?.trackAlbum ?? ""
                }

                // the leftover column height (the art overshoot) splits evenly
                // around the controls: text on top, transport floating below it
                Item { Layout.fillHeight: true }

                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: root.padding

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

                Item { Layout.fillHeight: true }
            }
        }

        // footer: elapsed / total around a progress bar spanning the full panel width,
        // art included; hidden when the player reports no track length. When seeking is
        // allowed, hovering thickens the bar into a scrubber with a playhead knob and a
        // cursor-time readout; click or drag commits the seek on release
        RowLayout {
            visible: root.trackLength > 0
            Layout.fillWidth: true
            spacing: Config.spaceWidth

            Label {
                Layout.preferredWidth: timeMetrics.advanceWidth
                horizontalAlignment: Text.AlignRight
                color: Colors.foregroundMuted
                text: root.formatTime(seekArea.pressed
                    ? seekArea.targetFraction * root.trackLength : root.trackPosition)
            }

            Item {
                id: progressArea

                // position is writable only under both flags (see MprisPlayer docs)
                readonly property bool seekable: (root.player?.canSeek ?? false)
                    && (root.player?.positionSupported ?? false)
                readonly property bool engaged: seekable
                    && (seekArea.containsMouse || seekArea.pressed)
                // the fill previews the scrub target while pressed, tracks playback otherwise
                readonly property real fraction: seekArea.pressed
                    ? seekArea.targetFraction
                    : (root.trackLength > 0
                        ? Math.min(1, root.trackPosition / root.trackLength) : 0)

                Layout.fillWidth: true
                // reserves the engaged height up front so the layout never shifts
                Layout.preferredHeight: 4 * Config.lineSize

                Rectangle {
                    id: track
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    // a quiet line at rest, a scrubber while engaged
                    height: (progressArea.engaged ? 4 : 2) * Config.lineSize
                    radius: height / 2
                    color: Colors.progressTrack

                    Behavior on height {
                        NumberAnimation { duration: 100 }
                    }

                    Rectangle {
                        height: parent.height
                        width: parent.width * progressArea.fraction
                        radius: parent.radius
                        color: Colors.progress
                    }
                }

                // playhead knob riding the end of the fill
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: progressArea.fraction * track.width - width / 2
                    width: 6 * Config.lineSize
                    height: width
                    radius: width / 2
                    color: Colors.foreground
                    opacity: progressArea.engaged ? 1 : 0
                    scale: opacity

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                // where a click would land, following the cursor above the bar
                Rectangle {
                    x: Math.max(0, Math.min(parent.width - width, seekArea.mouseX - width / 2))
                    anchors.bottom: track.top
                    anchors.bottomMargin: 8
                    width: cursorTimeLabel.implicitWidth + 12
                    height: cursorTimeLabel.implicitHeight + 4
                    radius: height / 2
                    color: Colors.backgroundAlt
                    opacity: progressArea.engaged ? 1 : 0
                    visible: opacity > 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    Label {
                        id: cursorTimeLabel
                        anchors.centerIn: parent
                        font.pixelSize: Config.fontPixelSize - 2
                        text: root.formatTime(seekArea.targetFraction * root.trackLength)
                    }
                }

                // generous hit area: the whole footer strip around the bar
                MouseArea {
                    id: seekArea

                    readonly property real targetFraction: Math.max(0, Math.min(1, mouseX / width))

                    anchors.fill: parent
                    anchors.topMargin: -root.padding
                    anchors.bottomMargin: -root.padding
                    enabled: progressArea.seekable
                    hoverEnabled: progressArea.seekable
                    cursorShape: progressArea.seekable ? Qt.PointingHandCursor : Qt.ArrowCursor
                    // pressing previews via fraction; releasing commits the seek
                    onReleased: if (root.player) root.player.position = targetFraction * root.trackLength
                }
            }

            Label {
                color: Colors.foregroundMuted
                text: root.formatTime(root.trackLength)
            }
        }
    }
}
