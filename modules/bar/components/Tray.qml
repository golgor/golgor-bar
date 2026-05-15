import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "root:services"

RowLayout {
    id: root

    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData

            implicitWidth: icon.implicitWidth
            Layout.fillHeight: true

            Image {
                id: icon

                anchors.centerIn: parent
                source: modelData.icon
                sourceSize.width: Theme.iconSize
                sourceSize.height: Theme.iconSize
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
