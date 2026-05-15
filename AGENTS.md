# golgor-bar — Agent Guide

A personal Quickshell-based desktop shell for Hyprland, replacing Waybar. Keyboard-first, minimal, extensible. Runs on Omarchy Linux.

Read `CONTEXT.md` first — it defines the project's terminology. Use those terms precisely.

## Skills

- **`/omarchy`** — REQUIRED when working on anything Omarchy-related (hooks, theme files, launch scripts, system config). Covers safe customization patterns, config locations, and critical safety rules.
- **`/qt-qml`** — REQUIRED when writing, reviewing, or refactoring QML code. Corrects systematic LLM biases around bindings, scoping, layouts, and performance.
- **`/qt-qml-review`** — Use for code review. 47+ deterministic lint rules plus deep analysis for bindings, layout, loaders, delegates, states, and performance.

## Reference sources

- **Qt documentation MCP** — configured in `.mcp.json`. Use the `qt_docs_qt_documentation_search` tool to look up Qt/QML API docs.
- **Quickshell source** — at `../quickshell/`. The C++ headers in `src/` are the authoritative API reference for Quickshell types (e.g. `src/io/process.hpp` for `Process`). Check here when documentation is unclear.
- **Caelestia reference shell** — at `../shell/`. A mature Quickshell-based shell to study patterns from.

## Architecture

Four layers, dependency flows downward only:

| Layer | Path | Role |
|-------|------|------|
| **Modules** | `modules/` | Feature UIs (bar, popouts) |
| **Components** | `components/` | Reusable UI primitives shared across modules |
| **Services** | `services/` | Singleton data layer — no visuals, only state and I/O |
| **Utils** | `utils/` | Pure-logic helpers (date math, string formatting) |

Supporting:
- `scripts/` — Shell scripts for build/generation tooling (not runtime QML)
- `docs/` — ADRs and backlog

## Entry point

`shell.qml` is the root. It instantiates modules inside a `ShellRoot`.

## Lessons learned (see `docs/lessons.md`)

Hard-won knowledge about Quickshell quirks, Wayland layer shell positioning, and Omarchy integration. **Read this before making changes** — it will save you from repeating mistakes.

## Key decisions (see `docs/adr/`)

- **Pure QML, no build step** — no CMake, no C++ plugin. Launch via `qs -c golgor-bar`.
- **Delegate system UIs to TUIs** — no reimplemented WiFi/Bluetooth/Audio panels. Prefer Omarchy scripts (`omarchy-launch-wifi`, etc.) when they exist.
- **Theme generated from Omarchy** — `scripts/generate-theme.sh` produces `services/GeneratedTheme.qml`. Never edit that file manually.
- **Singleton service layer** — all system state lives in `services/` as singletons.

## External files rule

**Any change outside this repo** (hooks, symlinks, system config) **must be added to both `mise run install` and `mise run uninstall` in `mise.toml`.** This ensures the project is cleanly installable and removable.

Current external touchpoints:
- Symlink: `~/.config/quickshell/golgor-bar → this repo`
- Omarchy hooks: `~/.config/omarchy/hooks/theme-set.d/golgor-bar`
- Omarchy hooks: `~/.config/omarchy/hooks/font-set.d/golgor-bar`

## QML coding conventions

### Pragmas
- `pragma Singleton` on all services and utils
- `pragma ComponentBehavior: Bound` on files using `Repeater`, `Variants`, or delegate-based types

### Import order
```qml
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "relative/path"
import "root:services"
import "root:utils"
```

Qt modules first, then Quickshell, then relative/root imports.

### Naming
- **Files**: PascalCase, name matches root type (`Clock.qml` exports `Clock`)
- **Properties**: camelCase, `readonly` when not externally writable
- **Required properties**: always typed — `required property string name`
- **Functions**: camelCase, always type params and return — `function toggle(): void`
- **IDs**: camelCase, `id: root` on the root object of each file

### Theme and styling
- Read colours from `Theme.background`, `Theme.accent`, etc. — **never hardcode colour values**
- Read font from `Theme.fontFamily`, `Theme.fontSize` — **never hardcode font values**
- When shared styled wrappers exist in `components/`, use them instead of raw Qt types

### Anti-patterns
- Do not hardcode colours, fonts, or pixel values that should come from Theme
- Do not put system state in modules — it belongs in `services/`
- Do not manually edit `services/GeneratedTheme.qml` — edit `scripts/generate-theme.sh` and run `mise run generate-theme`
- Do not make external system changes without updating `mise.toml` install/uninstall tasks

## Commit convention

```
module: change description
```

Module names match directory names: `bar`, `services`, `components`, `utils`, `scripts`, `docs`.

For cross-cutting changes use `chore`, `fix`, `feat`, or `refactor`.

## Launch

```bash
# Install (first time or after adding new external touchpoints)
mise run install

# Run
qs -c golgor-bar
```
