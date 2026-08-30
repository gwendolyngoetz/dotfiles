import QtQuick
import qs
import qs.bar

// Power icon; left click slides open the session panel (see ShutdownPanel)
Module {
    id: root

    padding: 1
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: ""   // power-off
    }

    ShutdownPanel {
        id: panel
        anchorItem: root
        anchorHovered: root.hovered
    }

    onLeftClicked: panel.toggle()
}
