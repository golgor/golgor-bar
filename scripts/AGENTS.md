# Scripts — Agent Guide

Shell scripts for tooling and generation. These are **not** runtime QML — they run outside Quickshell.

## Current scripts

| Script | Purpose | Triggered by |
|--------|---------|-------------|
| `generate-theme.sh` | Parses Omarchy theme → `services/GeneratedTheme.qml` | Omarchy hooks, `mise run generate-theme`, `mise run install` |

## generate-theme.sh contract

**Input:**
- `~/.config/omarchy/current/theme/colors.toml` — colour definitions
- `~/.config/waybar/style.css` — font-family (same source as `omarchy font current`)

**Output:**
- `services/GeneratedTheme.qml` — a `pragma Singleton` QML file with `readonly property` declarations

**Rules:**
- Output must be a valid QML file with `pragma Singleton` and `import QtQuick`
- Every colour from `colors.toml` maps to a `readonly property color`
- Font maps to `readonly property string fontFamily`
- If an input file is missing, use hardcoded fallback values
- The generated file is gitignored — never commit it

## Omarchy hook integration

Scripts are linked into Omarchy's `.d/` hook directories via `mise run install`:

```
~/.config/omarchy/hooks/theme-set.d/golgor-bar → scripts/generate-theme.sh
~/.config/omarchy/hooks/font-set.d/golgor-bar  → scripts/generate-theme.sh
```

The `.d/` pattern allows multiple hooks to coexist without overwriting each other.

## Adding a new script

1. Create the script in `scripts/`
2. Make it executable: `chmod +x scripts/new-script.sh`
3. If it needs to run on an Omarchy event, add a symlink in the appropriate `.d/` hook directory
4. **Update `mise.toml`** — add the symlink to both `install` and `uninstall` tasks
5. Document the input/output contract in this file
