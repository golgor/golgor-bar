# golgor-bar

A personal Quickshell-based desktop shell for Hyprland, replacing Waybar. Keyboard-first, minimal, extensible. Runs on Omarchy Linux.

## Launch

```bash
# Install (first time or after adding new external touchpoints)
mise run install

# Run
qs -c golgor-bar
```

## Shortcuts

golgor-bar registers global shortcuts via the Hyprland `global` dispatcher and exposes all actions over IPC (`qs ipc call`). Bind whichever shortcuts you need in your `hyprland.conf`.

### Global shortcuts

Add these to `~/.config/hypr/hyprland.conf` (adjust keys to taste):

| Action | Suggested bind | GlobalShortcut name |
|--------|---------------|---------------------|
| Toggle calendar popout | `SUPER, C` | `golgor-bar:toggleCalendar` |

Example `hyprland.conf` line:

```
bind = SUPER, C, global, golgor-bar:toggleCalendar
```

> **Note:** Launcher actions (Bluetooth, WiFi, Audio, btop) are not registered as GlobalShortcuts because Omarchy already provides system-level keybinds for those. They are available via click and IPC only.

### IPC

All actions are also callable from scripts or the terminal:

```bash
qs ipc call bar toggleCalendar
qs ipc call bar launchBluetooth
qs ipc call bar launchWifi
qs ipc call bar launchAudio
qs ipc call bar launchBtop
```

List registered targets with `qs ipc show`.

### Adding new shortcuts

When adding a new action to golgor-bar:

1. Add the action function to `services/Actions.qml`.
2. Add a `GlobalShortcut` in `shell.qml` with `appid: "golgor-bar"` and a descriptive `name`.
3. Expose it via the `IpcHandler` in `shell.qml`.
4. Wire any UI click handler to call `Actions.yourAction()`.
5. **Update this table** with the new shortcut name and a suggested bind.
