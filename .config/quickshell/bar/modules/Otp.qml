import QtQuick
import Quickshell
import qs
import qs.bar

// [module/otp]: scripts/otp-button.sh printed a lock icon; click-left = otp-menu.sh,
// click-right = otp-default-selection.sh
Module {
    padding: 1
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: ""
    }

    onLeftClicked: Quickshell.execDetached([Quickshell.shellDir + "/scripts/otp-menu.sh"])
    onRightClicked: Quickshell.execDetached([Quickshell.shellDir + "/scripts/otp-default-selection.sh"])
}
