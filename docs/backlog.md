# Backlog — Deferred Features

Features discussed during design but explicitly deferred from v1.

## Priority
- ~~**Fix StatusIcons Process error**~~ — ✅ Fixed. `Process` from `Quickshell.Io` is now used correctly.
- ~~**Larger status icons / thicker bar**~~ — ✅ Bar height increased to 40px (`Theme.barHeight`), icons to 22px (`Theme.iconSize`).
- ~~**Visually separate system tray from status icons**~~ — ✅ Thin vertical divider (`components/Divider.qml`) between tray and status icons, auto-hides when tray is empty.
- ~~**Unified trigger system**~~ — ✅ `services/Actions.qml` singleton owns all actions. `GlobalShortcut` + `IpcHandler` in `shell.qml` provide hotkey and IPC triggers alongside click handlers.

## Bar Enhancements
- **Window icons in workspace indicators** — show app icons for windows in each workspace (requires app-to-icon mapping).
- ~~**Special workspaces**~~ — ✅ Nerd Font icons for Slack/Altus, accent highlight when visible, click to toggle. Icons auto-show when apps are running.
- **Tray popout** — expandable tray with richer per-item info.

## Indicators
- **Weather** — weather status in bar, similar to current Omarchy weather module.
- **Screen recording indicator** — shows when screen recording is active.
- **Notification silencing indicator** — shows when notifications are muted.
- **Idle indicator** — shows when idle inhibitor is active.

## Popouts & Dashboards
- **Dashboard expansion** — grow the calendar popout into a full dashboard (media player, performance stats, weather, etc.).
- **Side-edge popouts** — panels triggered from screen edges via hotkey. Example use case: cloud-sql-proxy mini-dashboard with status of 4 proxy connections.
- **Popout prototyping** — explore different shapes/styles for the organic chamfered popout aesthetic. Try variations anchored to different screen edges.

## System
- **Config system** — JSON config file with schema, per-monitor overrides (modeled after Caelestia's `shell.json`).
- **Notifications** — popup notifications + notification center.
- **OSD** — volume/brightness on-screen display overlays.
