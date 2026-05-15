pragma ComponentBehavior: Bound

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
            id: trayDelegate

            required property SystemTrayItem modelData

            implicitWidth: icon.implicitWidth
            Layout.fillHeight: true

            Image {
                id: icon

                anchors.centerIn: parent
                source: trayDelegate.modelData.icon
                sourceSize.width: Theme.iconSize
                sourceSize.height: Theme.iconSize
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        if (trayDelegate.modelData.onlyMenu && trayDelegate.modelData.hasMenu) {
                            const pos = icon.mapToItem(null, 0, icon.height);
                            trayDelegate.modelData.display(QsWindow.window, pos.x, pos.y);
                        } else {
                            trayDelegate.modelData.activate();
                        }
                    } else if (event.button === Qt.MiddleButton) {
                        trayDelegate.modelData.secondaryActivate();
                    } else if (event.button === Qt.RightButton) {
                        if (trayDelegate.modelData.hasMenu) {
                            const pos = icon.mapToItem(null, 0, icon.height);
                            trayDelegate.modelData.display(QsWindow.window, pos.x, pos.y);
                        }
                    }
                }
            }
        }
    }
}
