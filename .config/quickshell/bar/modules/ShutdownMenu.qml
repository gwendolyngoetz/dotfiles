import QtQuick
import Quickshell
import qs
import qs.bar

// Power icon; left click opens the session menu
Module {
    id: root

    padding: 1
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: "\uf011"   // power-off
    }

    Menu {
        id: menu
        anchorItem: root
        anchorHovered: root.hovered
        entries: [
            { icon: "\uf2f5", label: "Logout",   command: ["i3-msg", "exit"] },        // sign-out-alt
            { icon: "\uf236", label: "Sleep",    command: ["systemctl", "suspend"] },  // bed
            { separator: true },
            { icon: "\uf2f1", label: "Reboot",   command: ["reboot"] },                // sync-alt
            { separator: true },
            { icon: "\uf011", label: "Shutdown", command: ["poweroff"] }               // power-off
        ]

        onActivated: entry => Quickshell.execDetached(entry.command)
    }

    onLeftClicked: menu.toggle()
}
