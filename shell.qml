//@ pragma UseQApplication

import "modules/bar"
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "services"

ShellRoot {
    settings.watchFiles: true

    Bar {}

    // Global shortcuts — bind keys in hyprland.conf:
    //   bind = SUPER, C, global, golgor-bar:toggleCalendar
    GlobalShortcut {
        appid: "golgor-bar"
        name: "toggleCalendar"
        description: "Toggle calendar popout"
        onPressed: Actions.toggleCalendar()
    }

    // Refresh workspace/monitor state on events Quickshell doesn't handle natively
    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (["activespecial", "workspace", "moveworkspace", "focusedmon"].includes(event.name)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            }
        }
    }

    // IPC — callable from scripts: qs ipc call bar toggleCalendar
    IpcHandler {
        target: "bar"

        function toggleCalendar(): void { Actions.toggleCalendar(); }
        function launchBluetooth(): void { Actions.launchBluetooth(); }
        function launchWifi(): void { Actions.launchWifi(); }
        function launchAudio(): void { Actions.launchAudio(); }
        function launchBtop(): void { Actions.launchBtop(); }
    }
}
