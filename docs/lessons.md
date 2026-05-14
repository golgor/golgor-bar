# Lessons Learned

Hard-won knowledge from building golgor-bar. Read this before making changes.

## Quickshell / QML

### PanelWindow

- **Use `implicitHeight`, not `height`** — `height` is deprecated on PanelWindow and will warn.
- **Anchors control sizing** — `anchors.left: true` + `anchors.right: true` forces full screen width. To get a sized panel, only anchor one edge (e.g. `anchors.top: true`) and set `implicitWidth`.
- **`exclusiveZone`** must be set explicitly. `ExclusionMode.Normal` alone may not reserve space correctly. Set `exclusiveZone: implicitHeight + gap` for the bar.

### Overlay windows (popouts, dashboards)

- **Use the Caelestia pattern**: full-screen transparent `PanelWindow` with `ExclusionMode.Ignore`, anchored to all four edges, then position content as QML Items inside it. This avoids all layer shell positioning headaches.
- **`WlrLayershell.exclusionMode: ExclusionMode.Ignore`** — critical for overlay windows that need to position relative to the bar. Without this, the bar's exclusive zone pushes the overlay down.
- **`mask: Region {}`** — makes only a portion of the full-screen transparent window interactive. Clicks outside the Region pass through to windows below. Update the mask to match the visible content bounds.
- **Overlap by 1px** for seamless connections — when a popout should look attached to the bar, position it at `y: bar.implicitHeight - 1` so there's no sub-pixel gap.

### PopupWindow

- **Unreliable for our use case** — `PopupWindow` with `anchor.edges` and `anchor.gravity` didn't work as documented in Quickshell 0.3.0. The full-screen overlay approach is more reliable for bar popouts.
- **`grabFocus: true`** causes the popup to dismiss when clicking outside, but this fights with `HyprlandFocusGrab` and can cause show/hide loops.

### HyprlandFocusGrab

- **Include the bar window** — `windows: [popout, bar]`. If only the popout is listed, hovering/clicking the bar counts as "outside" and dismisses the popout.

### Rectangle per-corner radius

- **Qt 6.7+ supports `topLeftRadius`, `topRightRadius`, `bottomLeftRadius`, `bottomRightRadius`** on Rectangle. No need for stacked rectangles or clip hacks to get flat-top + rounded-bottom shapes.

### Process (launching commands)

- **`Process` is a QML type, not a global function** — it lives in `Quickshell.Io`. You must `import Quickshell.Io` and declare it as a component. There is no `Process.exec()` global.
- **Trigger with `running = true`** — declare `Process { id: foo; command: ["sh", "-lc", "..."] }`, then `foo.running = true` to launch. Setting `running = false` sends SIGTERM.
- **Commands are NOT run in a shell** — each argument must be a separate list element. Use `["sh", "-c", "your command"]` or `["sh", "-lc", "..."]` (login shell) for shell features.
- **Use `startDetached()` for fire-and-forget** — the subprocess survives Quickshell restarts/reloads.

### Properties

- **`visible` is FINAL on Item** — you cannot redeclare `property bool visible` on an Item subclass. Use a custom property like `showing` and bind `visible: showing`.
- **`Keys.onPressed` can't attach to non-Item types** — PopupWindow is not an Item. Use a `FocusScope` inside the window for key handling.

### Timers and bindings

- **Don't recreate bindings in Timer callbacks** — using `Qt.binding()` inside `onTriggered` creates a new binding every tick, causing subtle issues. Instead, update a property: `onTriggered: root.now = new Date()` and let declarative bindings react to it.

### Singletons

- **Register all singletons in `qmldir`** — a `pragma Singleton` file that isn't listed in `qmldir` will fail with "X is not a type". Both `GeneratedTheme` and `Theme` need entries.
- **Reference singletons by name, don't instantiate** — `GeneratedTheme.background` (correct) vs `GeneratedTheme {}` (wrong — you can't create instances of singletons).

### QML language

- **QML's scripting language is JavaScript** — all functions, property bindings, and signal handlers in `.qml` files are JS. There is no alternative. It's not "choosing JS" — it's inherent to QML.

## Hyprland integration

- **`HyprlandWorkspaces` is not a type** — use `Hyprland.workspaces.values` from `import Quickshell.Hyprland`. Filter with `.filter()`, sort with `.sort()`.
- **Workspace active state** — compare `modelData.id === Hyprland.focusedWorkspace?.id`, not a `.active` property on the workspace.

## Omarchy integration

- **Hooks use `.d/` directories** — `~/.config/omarchy/hooks/<name>.d/` allows multiple hooks per event. Single-file hooks (`~/.config/omarchy/hooks/<name>`) risk being overwritten by Omarchy updates. Always use the `.d/` pattern.
- **Font is derived from Waybar CSS** — `omarchy font current` parses `~/.config/waybar/style.css`. There's no dedicated font config file. The `font-set` hook receives the font name as `$1`.
- **Theme colours live in `colors.toml`** — at `~/.config/omarchy/current/theme/colors.toml`. TOML format, not readable by QML natively — hence the generator script.

## Mise

- **Tasks run from temp directories** — `BASH_SOURCE` resolves to a temp path. Use `dir = "{{config_root}}"` in `mise.toml` so `$PWD` is the repo root.
