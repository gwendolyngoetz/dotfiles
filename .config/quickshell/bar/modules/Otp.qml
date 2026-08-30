import QtQuick
import qs
import qs.bar

// Lock icon. Left click slides open the password-store panel (see OtpPanel); right click copies
// the default account's OTP straight away.
Module {
    id: root

    property string defaultAccount: "tools/github"

    padding: 1
    clickable: true

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: ""   // lock
    }

    OtpPanel {
        id: panel
        anchorItem: root
        anchorHovered: root.hovered
    }

    onLeftClicked: panel.toggle()
    onRightClicked: panel.copy(defaultAccount)
}
