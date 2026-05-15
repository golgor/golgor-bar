import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "components"
import "popouts"
import "root:components" as SharedComponents
import "root:services"

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.background

    exclusiveZone: implicitHeight + 4
    WlrLayershell.namespace: "golgor-bar"
    WlrLayershell.layer: WlrLayer.Top

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 0

        // Left section
        Workspaces {}

        // Center spacer
        Item { Layout.fillWidth: true }

        // Center section
        Clock {
            id: clock
            onClicked: Actions.toggleCalendar()
        }

        // Right spacer
        Item { Layout.fillWidth: true }

        // Right section
        Tray { id: tray }
        SharedComponents.Divider { visible: tray.implicitWidth > 0 }
        StatusIcons {}
    }

    Calendar {}

    // PROTOTYPE — delete when done
    PopoutPrototype {}
}
