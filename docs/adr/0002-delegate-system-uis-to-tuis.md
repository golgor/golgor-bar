# Delegate system UIs to existing TUIs instead of reimplementing

System interactions (WiFi scanning, Bluetooth pairing, audio mixing, process monitoring) launch existing TUI applications (`nmtui`, `bluetuith`, `pavucontrol`, `btop`) in floating Hyprland terminals rather than reimplementing them as Quickshell popouts. Where Omarchy provides launcher scripts (e.g. `omarchy-launch-wifi`, `omarchy-launch-bluetooth`), prefer those over calling TUIs directly.

Caelestia reimplements all of these as full QML popouts with custom network scanning, Bluetooth device lists, and audio controls. That's a massive surface area to build and maintain. The TUI approach gives us full functionality immediately with zero implementation cost, at the trade-off of a less visually integrated experience. Since we're keyboard-first anyway, dropping into a terminal TUI is natural.
