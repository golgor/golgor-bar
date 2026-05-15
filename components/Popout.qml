import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:services"

PanelWindow {
    id: root

    // --- Public API ---
    // Usage:
    // Popout {
    //     edge: root.edgeRight
    //     popoutName: "calendar"
    //     showing: Actions.calendarVisible
    //     glass: true
    //     dismissOnFocusLoss: true
    //     onDismissed: Actions.calendarVisible = false
    // }

    // Control visibility — bind to an Actions property
    property bool showing: false

    // Internal visibility so exit animation can finish before window hides
    property bool windowVisible: showing

    // Edge constants + selected edge
    readonly property int edgeTop: 0
    readonly property int edgeLeft: 1
    readonly property int edgeRight: 2
    property int edge: edgeTop

    // Namespace suffix for WlrLayershell (must be unique per popout)
    property string popoutName: "popout"

    // Corner radii for the sides away from the edge
    property real cornerRadius: 16
    property real organicRadius: 6

    // Semi-transparent background with optional Hyprland blur
    property bool glass: false

    // Content padding
    property real contentPadding: 16

    // Position along edge axis:
    // - top edge: 0 = left, 1 = right
    // - left/right edge: 0 = top, 1 = bottom
    property real positionRatio: 0.5
    property real positionOffsetPx: 0

    // Distance inward from the attached edge
    property real edgeInsetPx: 0

    // Parent window to include in focus grab (e.g. the bar)
    // Prevents clicks on the parent from dismissing the popout
    property var parentWindow: null

    property bool dismissOnFocusLoss: true

    // Emitted when focus grab clears — caller should set showing = false
    signal dismissed()

    // Content slot
    default property alias content: contentSlot.data

    function clamp(value: real, minValue: real, maxValue: real): real {
        return Math.max(minValue, Math.min(maxValue, value));
    }

    // --- Window setup ---

    visible: root.windowVisible

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: "golgor-bar-" + root.popoutName
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    mask: Region {
        x: popoutBg.x + slideTransform.x
        y: popoutBg.y + slideTransform.y
        width: popoutBg.width
        height: popoutBg.height
    }

    HyprlandFocusGrab {
        active: root.showing && root.dismissOnFocusLoss
        windows: root.parentWindow ? [root, root.parentWindow] : [root]
        onCleared: root.dismissed()
    }

    Timer {
        id: hideTimer
        interval: 350
        repeat: false
        onTriggered: {
            if (!root.showing)
                root.windowVisible = false;
        }
    }

    onShowingChanged: {
        if (showing) {
            hideTimer.stop();
            windowVisible = true;
        } else {
            hideTimer.restart();
        }
    }

    // --- Popout body ---

    Rectangle {
        id: popoutBg

        width: contentSlot.implicitWidth + root.contentPadding * 2
        height: contentSlot.implicitHeight + root.contentPadding * 2

        // Position: edge-attached with configurable axis placement
        x: {
            const maxX = Math.max(0, parent.width - width);
            const clampedRatio = root.clamp(root.positionRatio, 0, 1);

            switch (root.edge) {
            case root.edgeRight:
                return parent.width - width - root.edgeInsetPx;
            case root.edgeLeft:
                return root.edgeInsetPx;
            default: {
                const centerX = parent.width * clampedRatio + root.positionOffsetPx;
                return root.clamp(centerX - width / 2, 0, maxX);
            }
            }
        }
        y: {
            const maxY = Math.max(0, parent.height - height);
            const clampedRatio = root.clamp(root.positionRatio, 0, 1);

            switch (root.edge) {
            case root.edgeTop:
                return Theme.barHeight - 1 + root.edgeInsetPx;
            default: {
                const centerY = parent.height * clampedRatio + root.positionOffsetPx;
                return root.clamp(centerY - height / 2, 0, maxY);
            }
            }
        }

        // Corner radii: flat on the edge side, rounded on outer sides
        // One outer corner uses organicRadius for asymmetric feel
        topLeftRadius: {
            if (root.edge === root.edgeTop || root.edge === root.edgeLeft)
                return 0;
            return root.cornerRadius;
        }
        topRightRadius: {
            if (root.edge === root.edgeTop || root.edge === root.edgeRight)
                return 0;
            return root.cornerRadius;
        }
        bottomLeftRadius: {
            if (root.edge === root.edgeLeft)
                return 0;
            if (root.edge === root.edgeTop)
                return root.cornerRadius;
            return root.organicRadius;
        }
        bottomRightRadius: {
            if (root.edge === root.edgeRight)
                return 0;
            if (root.edge === root.edgeTop)
                return root.organicRadius;
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
            case root.edgeRight:
                return Item.Right;
            case root.edgeLeft:
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
                if (root.showing)
                    return 0;
                switch (root.edge) {
                case root.edgeRight:
                    return 80;
                case root.edgeLeft:
                    return -80;
                default:
                    return 0;
                }
            }
            y: root.edge === root.edgeTop && !root.showing ? -50 : 0

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
            id: contentSlot

            x: root.contentPadding
            y: root.contentPadding

            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
