# Bar Module — Agent Guide

The top status bar. This is the primary module and where most development happens.

## Structure

```
modules/bar/
├── Bar.qml              # Entry point — PanelWindow with left/center/right layout
├── components/          # Bar-specific UI components
│   ├── Workspaces.qml   # Dynamic Hyprland workspace indicators
│   ├── Clock.qml        # Date + ISO week number + time
│   ├── Tray.qml         # System tray (always visible)
│   └── StatusIcons.qml  # BT, Network, Audio, CPU — status + TUI launchers
└── popouts/             # Floating panels anchored to bar items
    └── Calendar.qml     # Month calendar with week numbers
```

## Bar layout

Left → Center → Right, using `RowLayout` with spacers:

```
| Workspaces |     ←spacer→     | Clock |     ←spacer→     | Tray | StatusIcons |
```

## Adding a bar component

1. Create `components/NewComponent.qml`
2. Add it to the appropriate section in `Bar.qml`'s `RowLayout`
3. Read all styling from `Theme` service — no hardcoded values
4. For system interactions, prefer Omarchy scripts (e.g. `omarchy-launch-wifi`)

## Popout pattern

Popouts are floating panels that drop from the bar, anchored to a trigger component. They share these behaviors:

- **Toggle**: same hotkey or click opens/closes
- **Dismiss**: Escape key, click-outside, or toggle hotkey
- **Keyboard navigable**: arrow keys, Enter, Escape at minimum
- **Styled**: organic chamfered shape, attached to bar visually

### Adding a new popout

1. Create `popouts/NewPopout.qml`
2. The popout needs an `anchor` property pointing to its trigger component in the bar
3. Implement `toggle()` and `close()` functions
4. Wire dismiss behavior: Escape, click-outside, toggle hotkey
5. Wire the trigger in `Bar.qml`

## System UI rule

**Do NOT reimplement system UIs.** Bar status icons show state and launch existing TUIs:

| Icon | Status source | Click action |
|------|--------------|--------------|
| Bluetooth | Quickshell API | `omarchy-launch-bluetooth` |
| Network | Quickshell API | `omarchy-launch-wifi` |
| Audio | Quickshell API | `omarchy-launch-audio` |
| CPU | Quickshell API | `omarchy-launch-or-focus-tui btop` |
| Battery | Quickshell API | Status display only (auto-hidden when no battery present) |

If an Omarchy launch script exists for the interaction, use it. See ADR 0002.
