import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.bar

// Spotify "title - artist" cut to 30 characters, from Mpris; click jumps to workspace 10
Module {
    id: root

    readonly property MprisPlayer player: Mpris.players.values.find(p =>
        p.dbusName === "org.mpris.MediaPlayer2.spotify" || p.identity === "Spotify") ?? null

    active: player !== null
    text: player ? `${player.trackTitle} - ${player.trackArtist}`.slice(0, 30) : ""
    prefix: " "
    prefixStyle: "brands"
    prefixColor: Colors.spotify
    foreground: Colors.foreground
    background: Colors.background
    underline: Colors.spotify
    padding: 1
    clickable: true

    onLeftClicked: Quickshell.execDetached(["i3-msg", "workspace 10:"])
}
