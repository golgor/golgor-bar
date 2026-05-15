pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:components" as SharedComponents
import "root:services"

RowLayout {
    id: root

    spacing: 4

    // Regular workspaces
    Repeater {
        model: Hyprland.workspaces.values.filter(ws => !ws.name.startsWith("special:")).sort((a, b) => a.id - b.id)

        delegate: Item {
            id: wsDelegate

            required property var modelData

            readonly property bool isFocused: wsDelegate.modelData.id === Hyprland.focusedWorkspace?.id

            implicitWidth: label.implicitWidth + 12
            implicitHeight: parent.height

            Text {
                id: label

                anchors.centerIn: parent
                text: wsDelegate.modelData.id
                color: wsDelegate.isFocused ? Theme.accent : Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: wsDelegate.isFocused
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsDelegate.modelData.id)
            }
        }
    }

    // Divider between regular and special workspaces
    SharedComponents.Divider {
        visible: specialRepeater.count > 0
    }

    // Special workspaces (scratchpads)
    Repeater {
        id: specialRepeater

        model: Hyprland.workspaces.values
            .filter(ws => ws.name.startsWith("special:"))
            .sort((a, b) => a.id - b.id)

        delegate: Item {
            id: specialDelegate

            required property var modelData

            readonly property string specialName: specialDelegate.modelData.name.slice(8)
            readonly property bool isShown: {
                const active = Hyprland.focusedMonitor?.lastIpcObject?.specialWorkspace?.name ?? "";
                return active === specialDelegate.modelData.name;
            }

            implicitWidth: iconLabel.implicitWidth + 12
            implicitHeight: parent.height

            Text {
                id: iconLabel

                anchors.centerIn: parent
                text: {
                    switch (specialDelegate.specialName) {
                    case "slack":
                        return "\u{f0372}"; // 󰍲 nf-md-slack
                    case "altus":
                        return "\u{f05a3}"; // 󰖣 nf-md-whatsapp
                    default:
                        return specialDelegate.specialName[0].toUpperCase();
                    }
                }
                color: specialDelegate.isShown ? Theme.accent : Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize
                font.bold: specialDelegate.isShown
                opacity: specialDelegate.isShown ? 1.0 : 0.6
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("togglespecialworkspace " + specialDelegate.specialName)
            }
        }
    }
}
