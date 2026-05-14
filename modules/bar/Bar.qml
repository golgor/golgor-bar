import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "components"
import "popouts"
import "root:services"

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32
    color: Theme.background

    exclusiveZone: implicitHeight + margins.top + margins.bottom

    margins {
        top: 4
        left: 8
        right: 8
    }
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
        }

        // Right spacer
        Item { Layout.fillWidth: true }

        // Right section
        Tray {}
        StatusIcons {}
    }

    Calendar {
        id: calendarPopout
        anchor: clock
    }
}
