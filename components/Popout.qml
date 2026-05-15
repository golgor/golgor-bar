import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:services"

PanelWindow {
    id: root

    // --- Public API ---

    // Control visibility — bind to an Actions property
    property bool showing: false

    // Which screen edge to attach to: "top", "left", "right"
    property string edge: "top"

    // Namespace suffix for WlrLayershell (must be unique per popout)
    property string name: "popout"

    // Corner radii for the sides away from the edge
    property real cornerRadius: 16
    property real organicRadius: 6

    // Semi-transparent background with optional Hyprland blur
    property bool glass: false

    // Content padding
    property real contentPadding: 16

    // Parent window to include in focus grab (e.g. the bar)
    // Prevents clicks on the parent from dismissing the popout
    property var parentWindow: null

    // Emitted when focus grab clears — caller should set showing = false
    signal dismissed()

    // Content slot
    default property alias content: contentItem.data

    // --- Window setup ---

    visible: root.showing

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: "golgor-bar-" + root.name
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    mask: Region {
        x: popoutBg.x
        y: popoutBg.y
        width: popoutBg.width
        height: popoutBg.height
    }

    HyprlandFocusGrab {
        active: root.showing
        windows: root.parentWindow ? [root, root.parentWindow] : [root]
        onCleared: root.dismissed()
    }

    // --- Popout body ---

    Rectangle {
        id: popoutBg

        width: contentItem.implicitWidth + root.contentPadding * 2
        height: contentItem.implicitHeight + root.contentPadding * 2

        // Position: flush against the specified edge
        x: {
            switch (root.edge) {
            case "right":
                return parent.width - width;
            case "left":
                return 0;
            default:
                return (parent.width - width) / 2;
            }
        }
        y: {
            switch (root.edge) {
            case "top":
                return Theme.barHeight - 1;
            default:
                return (parent.height - height) / 2;
            }
        }

        // Corner radii: flat on the edge side, rounded on outer sides
        // One outer corner uses organicRadius for asymmetric feel
        topLeftRadius: {
            if (root.edge === "top" || root.edge === "left") return 0;
            return root.cornerRadius;
        }
        topRightRadius: {
            if (root.edge === "top" || root.edge === "right") return 0;
            return root.cornerRadius;
        }
        bottomLeftRadius: {
            if (root.edge === "left") return 0;
            if (root.edge === "top") return root.cornerRadius;
            return root.organicRadius;
        }
        bottomRightRadius: {
            if (root.edge === "right") return 0;
            if (root.edge === "top") return root.organicRadius;
            return root.cornerRadius;
        }

        // Background
        color: root.glass
            ? Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.55)
            : Theme.background

        border.width: root.glass ? 1 : 0
        border.color: root.glass
            ? Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.15)
            : "transparent"

        // --- Animation ---

        opacity: root.showing ? 1 : 0
        scale: root.showing ? 1 : 0.85

        transformOrigin: {
            switch (root.edge) {
            case "right":
                return Item.Right;
            case "left":
                return Item.Left;
            default:
                return Item.Top;
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 350; easing.type: Easing.OutBack }
        }

        Translate {
            id: slideTransform

            x: {
                if (root.showing) return 0;
                switch (root.edge) {
                case "right": return 80;
                case "left": return -80;
                default: return 0;
                }
            }
            y: root.edge === "top" && !root.showing ? -50 : 0

            Behavior on x {
                NumberAnimation { duration: 350; easing.type: Easing.OutBack }
            }
            Behavior on y {
                NumberAnimation { duration: 350; easing.type: Easing.OutBack }
            }
        }
        transform: slideTransform

        // Content container
        Item {
            id: contentItem
            anchors.fill: parent
            anchors.margins: root.contentPadding
        }
    }
}
