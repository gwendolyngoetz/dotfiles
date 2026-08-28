import QtQuick
import Quickshell
import Quickshell.Io
import qs

// Application launcher (desktop entries with icons).
//
// Toggle with: qs ipc call launcher toggle
// i3 floats it via: for_window [class="quickshell" title="launcher"] floating enable, border none
FloatingWindow {
    id: win

    readonly property int windowWidth: 700
    readonly property int windowHeight: 438

    title: "launcher"
    visible: false
    color: "transparent"
    implicitWidth: windowWidth
    implicitHeight: windowHeight
    minimumSize: Qt.size(windowWidth, windowHeight)
    maximumSize: Qt.size(windowWidth, windowHeight)

    function show() {
        view.query = "";
        view.currentIndex = 0;
        win.visible = true;
        view.focusEntry();
    }

    function hide() {
        win.visible = false;
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void { win.visible ? win.hide() : win.show(); }
        function show(): void { win.show(); }
        function hide(): void { win.hide(); }
    }

    LauncherView {
        id: view
        anchors.fill: parent
        onAccepted: win.hide()
        onDismissed: win.hide()
    }
}
