pragma Singleton

import QtQuick

QtObject {
    id: root

    // Colours from GeneratedTheme with fallback defaults
    readonly property color background: GeneratedTheme.background ?? "#060B1E"
    readonly property color foreground: GeneratedTheme.foreground ?? "#ffcead"
    readonly property color accent: GeneratedTheme.accent ?? "#7d82d9"

    readonly property color color0: GeneratedTheme.color0 ?? "#3C486D"
    readonly property color color1: GeneratedTheme.color1 ?? "#ED5B5A"
    readonly property color color2: GeneratedTheme.color2 ?? "#92a593"
    readonly property color color3: GeneratedTheme.color3 ?? "#E9BB4F"
    readonly property color color4: GeneratedTheme.color4 ?? "#7d82d9"
    readonly property color color5: GeneratedTheme.color5 ?? "#c89dc1"
    readonly property color color6: GeneratedTheme.color6 ?? "#a3bfd1"
    readonly property color color7: GeneratedTheme.color7 ?? "#F99957"
    readonly property color color8: GeneratedTheme.color8 ?? "#6d7db6"
    readonly property color color9: GeneratedTheme.color9 ?? "#faaaa9"
    readonly property color color10: GeneratedTheme.color10 ?? "#c4cfc4"
    readonly property color color11: GeneratedTheme.color11 ?? "#f7dc9c"
    readonly property color color12: GeneratedTheme.color12 ?? "#c2c4f0"
    readonly property color color13: GeneratedTheme.color13 ?? "#ead7e7"
    readonly property color color14: GeneratedTheme.color14 ?? "#dfeaf0"
    readonly property color color15: GeneratedTheme.color15 ?? "#ffcead"

    readonly property string fontFamily: GeneratedTheme.fontFamily ?? "CaskaydiaMono Nerd Font Mono"
    readonly property int fontSize: GeneratedTheme.fontSize ?? 12
}
