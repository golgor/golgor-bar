# Generate QML theme from Omarchy's theme files

Colours and fonts are sourced from Omarchy's active theme (`~/.config/omarchy/current/theme/colors.toml` and font settings) via a generator script (`scripts/generate-theme.sh`) that produces a QML singleton (`services/GeneratedTheme.qml`).

QML has no native TOML parser, so we can't read `colors.toml` directly. Alternatives considered:
- Converting to JSON first and parsing in QML — adds a runtime dependency on the conversion step
- Hardcoding colours — breaks on theme switch
- Own theming system — duplicates what Omarchy already provides

The generator script is triggered by Omarchy's `theme-set` and `font-set` hooks. The generated file is gitignored. A single Theme service wraps the generated file and exposes properties to all components.
