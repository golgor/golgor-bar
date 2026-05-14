import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:services"

RowLayout {
    id: root

    spacing: 4

    Repeater {
        model: Hyprland.workspaces.values.filter(ws => !ws.name.startsWith("special:")).sort((a, b) => a.id - b.id)

        delegate: Item {
            required property var modelData

            implicitWidth: label.implicitWidth + 12
            implicitHeight: parent.height

            Text {
                id: label

                anchors.centerIn: parent
                text: modelData.id
                color: modelData.id === Hyprland.focusedWorkspace?.id ? Theme.accent : Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: modelData.id === Hyprland.focusedWorkspace?.id
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }
        }
    }
}
