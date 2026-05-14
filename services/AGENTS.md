# Services — Agent Guide

Singleton data layer. Every file here owns a slice of system state and exposes reactive properties. **No visual elements.** See ADR 0004 for why this pattern was chosen.

## Pattern

Every service follows this structure:

```qml
pragma Singleton

import QtQuick

QtObject {
    id: root

    readonly property string someValue: "..."
}
```

- Root type is `QtObject` (or `Singleton` if using Quickshell's type)
- `pragma Singleton` at the top of every file
- `id: root` on the root object
- `readonly property` for all exposed state
- Register in `qmldir`: `singleton ServiceName 1.0 ServiceName.qml`

## Current services

| Service | Purpose | Notes |
|---------|---------|-------|
| `Theme` | Colours and font properties | Wraps `GeneratedTheme` with fallback defaults |
| `GeneratedTheme` | Raw theme values from Omarchy | **Auto-generated — never edit manually** |

## Theme service specifics

`Theme.qml` is the single source of truth for all styling. It imports `GeneratedTheme.qml` and provides fallback values for development without generation.

```
Omarchy theme change
  → hook fires
    → scripts/generate-theme.sh
      → writes services/GeneratedTheme.qml
        → Theme.qml exposes to all consumers
```

To regenerate: `mise run generate-theme`

## Adding a new service

1. Create `ServiceName.qml` with `pragma Singleton`
2. Add to `qmldir`: `singleton ServiceName 1.0 ServiceName.qml`
3. Use `readonly property` for all state exposed to consumers
4. For external process data, use Quickshell's `Process` + `StdioCollector`
5. For polling, use `Timer` with appropriate intervals

## Rules

- **No visual elements** — services own data, not UI
- **No module dependencies** — services never import from `modules/`. Dependency flows one way: modules → services
- **No component dependencies** — services never import from `components/`
- Services may depend on other services and on `utils/`
- Access from anywhere by singleton name: `Theme.background`, `Theme.fontFamily`
