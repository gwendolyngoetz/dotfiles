import QtQuick
import Quickshell
import qs
import qs.bar

// [module/shutdown-menu]: scripts/xmenu-button.sh printed a power icon; click-left = shutdown-menu.sh
Module {
    padding: 1
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: "\uf011"   // power-off
    }

    onLeftClicked: Quickshell.execDetached([Quickshell.shellDir + "/scripts/shutdown-menu.sh"])
}
