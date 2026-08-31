import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.bar

// Spotify "title - artist" cut to 30 characters, from Mpris, dimmed while paused; left click
// slides open the player panel (see SpotifyPanel), right click jumps to workspace 10
Module {
    id: root

    readonly property MprisPlayer player: Mpris.players.values.find(p =>
        p.dbusName === "org.mpris.MediaPlayer2.spotify" || p.identity === "Spotify") ?? null
    readonly property bool playing: player?.playbackState === MprisPlaybackState.Playing

    active: player !== null
    text: player ? `${player.trackTitle} - ${player.trackArtist}`.slice(0, 30) : ""
    prefix: " "
    prefixStyle: "brands"
    prefixColor: Colors.spotify
    foreground: Colors.foreground
    background: Colors.background
    padding: 1
    clickable: true
    // paused reads at a glance, matching the panel's art dim
    opacity: playing ? 1 : 0.5

    Behavior on opacity { NumberAnimation { duration: 150 } }

    SpotifyPanel {
        id: panel
        anchorItem: root
        anchorHovered: root.hovered
        player: root.player
    }

    onLeftClicked: panel.toggle()
    onRightClicked: Quickshell.execDetached(["i3-msg", "workspace 10:"])
}
