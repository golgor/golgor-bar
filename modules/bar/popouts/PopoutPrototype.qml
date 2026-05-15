// PROTOTYPE — Demonstrates Popout component with 3 edge configurations
// Toggle: Super+P or `qs ipc call bar togglePrototype`
// Delete when done.
//
// For blur on glass popouts:
//   hyprctl keyword layerrule blur,golgor-bar-proto-right
//   hyprctl keyword layerrule ignorealpha 0.3,golgor-bar-proto-right

import QtQuick
import QtQuick.Layouts
import "root:components" as SharedComponents
import "root:services"

Item {
    id: root

    // --- TOP CENTER: solid, chamfered classic ---
    SharedComponents.Popout {
        edge: "top"
        name: "proto-top"
        showing: Actions.prototypeVisible
        parentWindow: bar
        cornerRadius: 20
        organicRadius: 8
        onDismissed: Actions.prototypeVisible = false

        ColumnLayout {
            spacing: 8
            implicitWidth: 260

            Text { text: "Top · Chamfered"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
            Text { text: "Flat top (connects to bar), rounded\nbottom with organic asymmetry.\nThis is where the dashboard lives."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
            Text { text: "edge: \"top\"  cornerRadius: 20"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.08 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.10 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.06 }
        }
    }

    // --- RIGHT EDGE: glass, flush right ---
    SharedComponents.Popout {
        edge: "right"
        name: "proto-right"
        showing: Actions.prototypeVisible
        parentWindow: bar
        glass: true
        cornerRadius: 16
        organicRadius: 6
        onDismissed: Actions.prototypeVisible = false

        ColumnLayout {
            spacing: 8
            implicitWidth: 220

            Text { text: "Right · Glass"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
            Text { text: "Flush right edge, rounded left.\nSemi-transparent glass effect.\nSide panel for controls."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
            Text { text: "edge: \"right\"  glass: true"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.08 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.10 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.06 }
        }
    }

    // --- LEFT EDGE: solid, flush left ---
    SharedComponents.Popout {
        edge: "left"
        name: "proto-left"
        showing: Actions.prototypeVisible
        parentWindow: bar
        cornerRadius: 16
        organicRadius: 6
        onDismissed: Actions.prototypeVisible = false

        ColumnLayout {
            spacing: 8
            implicitWidth: 220

            Text { text: "Left · Solid"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
            Text { text: "Flush left edge, rounded right.\nSolid background.\nCloud-sql controls here?"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
            Text { text: "edge: \"left\"  glass: false"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.08 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.10 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.06 }
        }
    }
}
