import QtQuick
import QtQuick.Layouts
import "root:services"

RowLayout {
    id: root

    spacing: 12

    // Bluetooth
    Text {
        text: ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Actions.launchBluetooth()
        }
    }

    // Network
    Text {
        text: "󰤨"
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Actions.launchWifi()
        }
    }

    // Audio
    Text {
        text: ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Actions.launchAudio()
        }
    }

    // CPU
    Text {
        text: "󰍛"
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Actions.launchBtop()
        }
    }
}
