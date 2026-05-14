import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: root

    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData

            implicitWidth: icon.implicitWidth
            implicitHeight: bar.height

            Image {
                id: icon

                anchors.centerIn: parent
                source: modelData.icon
                sourceSize.width: 16
                sourceSize.height: 16
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton)
                        modelData.activate();
                    else
                        modelData.activate();
                }
            }
        }
    }
}
