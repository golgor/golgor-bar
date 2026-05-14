import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
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
            cursorShape: Qt.PointingHandCursor
            onClicked: bluetoothProc.running = true
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
            cursorShape: Qt.PointingHandCursor
            onClicked: wifiProc.running = true
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
            cursorShape: Qt.PointingHandCursor
            onClicked: audioProc.running = true
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
            cursorShape: Qt.PointingHandCursor
            onClicked: btopProc.running = true
        }
    }

    Process {
        id: bluetoothProc
        command: ["sh", "-lc", "omarchy launch bluetooth"]
    }

    Process {
        id: wifiProc
        command: ["sh", "-lc", "omarchy launch wifi"]
    }

    Process {
        id: audioProc
        command: ["sh", "-lc", "omarchy launch audio"]
    }

    Process {
        id: btopProc
        command: ["sh", "-lc", "omarchy launch or focus tui btop"]
    }
}
