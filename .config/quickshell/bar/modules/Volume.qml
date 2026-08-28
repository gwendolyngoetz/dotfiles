import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs
import qs.bar

// [module/pulseaudio]: format-volume = <ramp-volume> (icon only), label-muted, scroll = +/-5%,
// click-right = pavucontrol -t 4; internal/pulseaudio toggles mute on left click by default
Module {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    readonly property int percentage: audio ? Math.round(audio.volume * 100) : 0
    readonly property var ramp: [" ", " ", " "]

    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    active: audio !== null
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: root.audio && root.audio.muted ? " "
            : root.ramp[Math.min(2, Math.max(0, Math.round(root.percentage * 2 / 100)))]
    }

    onLeftClicked: if (audio) audio.muted = !audio.muted
    onRightClicked: Quickshell.execDetached(["pavucontrol", "-t", "4"])

    onScrolled: delta => {
        if (!audio) return;

        const step = delta > 0 ? 0.05 : -0.05;
        audio.volume = Math.min(1, Math.max(0, audio.volume + step));
    }
}
