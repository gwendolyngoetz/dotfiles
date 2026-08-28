import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.bar

// Lock icon. Left click lists the password-store entries and copies the chosen one's OTP to the
// clipboard; right click copies the default account straight away.
Module {
    id: root

    property string defaultAccount: "work"
    property var accounts: []

    padding: 1
    clickable: true

    function copy(account) {
        Quickshell.execDetached([Quickshell.shellDir + "/scripts/otp-copy.sh", account]);
    }

    Icon {
        iconStyle: "solid"
        color: Colors.foreground
        text: "\uf023"   // lock
    }

    Process {
        id: lister
        command: ["bash", "-c", "ls ~/.password-store | sort"]

        stdout: StdioCollector {
            onStreamFinished: root.accounts = this.text.split("\n")
                .map(l => l.trim())
                .filter(l => l !== "")
                .map(l => l.replace(/\.[^.]*$/, ""))
        }
    }

    Menu {
        id: menu
        anchorItem: root
        anchorHovered: root.hovered
        entries: root.accounts.map(a => ({ icon: "\uf084", label: a, account: a }))   // key

        onActivated: entry => root.copy(entry.account)
        onVisibleChanged: if (visible) lister.running = true
    }

    onLeftClicked: menu.toggle()
    onRightClicked: copy(defaultAccount)
}
