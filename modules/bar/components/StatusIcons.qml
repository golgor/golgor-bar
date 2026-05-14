import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:services"

RowLayout {
    id: root

    spacing: 12

    // Bluetooth
    Text {
        text: ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        MouseArea {
            anchors.fill: parent
            onClicked: Process.exec(["omarchy-launch-bluetooth"])
        }
    }

    // Network
    Text {
        text: "󰤨"
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        MouseArea {
            anchors.fill: parent
            onClicked: Process.exec(["omarchy-launch-wifi"])
        }
    }

    // Audio
    Text {
        text: ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        MouseArea {
            anchors.fill: parent
            onClicked: Process.exec(["omarchy-launch-audio"])
        }
    }

    // CPU
    Text {
        text: "󰍛"
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        MouseArea {
            anchors.fill: parent
            onClicked: Process.exec(["omarchy-launch-or-focus-tui", "btop"])
        }
    }
}
