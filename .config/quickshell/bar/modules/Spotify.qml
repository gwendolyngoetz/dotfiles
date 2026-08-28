import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.bar

// [module/spotify]: scripts/spotify.sh read MPRIS metadata over dbus every second and printed
// "title - artist" cut to 30 characters. Same data straight from the Mpris service, no polling.
Module {
    id: root

    readonly property var player: Mpris.players.values.find(p =>
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
