# Backlog — Deferred Features

Features discussed during design but explicitly deferred from v1.

## Bar Enhancements
- **Auto-hide bar mode** — bar slides away, appears on hover/gesture. Design Bar/BarWrapper split to support this later.
- **Window icons in workspace indicators** — show app icons for windows in each workspace (requires app-to-icon mapping).
- **Special workspaces** — show Super+S (Slack) and Super+Q (Altus/WhatsApp) scratchpads in the bar.
- **Tray popout** — expandable tray with richer per-item info.
- **Logo/menu button** — session menu (lock/logout/shutdown) trigger.

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
- **Launcher** — app launcher (keyboard-driven).
