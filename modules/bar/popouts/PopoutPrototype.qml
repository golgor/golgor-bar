// PROTOTYPE — single popout for interaction testing
// Toggle: Super+P or `qs ipc call bar togglePrototype`

import QtQuick
import QtQuick.Layouts
import "root:components" as SharedComponents
import "root:services"

Item {
    id: root

    SharedComponents.Popout {
        edge: "right"
        popoutName: "proto-right"
        showing: Actions.prototypeVisible
        parentWindow: bar
        dismissOnFocusLoss: true

        glass: true
        cornerRadius: 16
        organicRadius: 6

        onDismissed: Actions.prototypeVisible = false

        ColumnLayout {
            spacing: 8
            implicitWidth: 240

            Text {
                text: "Right · Single Prototype"
                color: Theme.accent
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 2
                font.bold: true
            }

            Text {
                text: "Flush right edge, rounded left,\norganic lower corner, glass style.\nClick outside to close."
                color: Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
                opacity: 0.7
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.08 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.10 }
            Rectangle { Layout.fillWidth: true; height: 14; radius: 4; color: Theme.foreground; opacity: 0.06 }
        }
    }
}
