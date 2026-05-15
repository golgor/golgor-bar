// PROTOTYPE — Throwaway popout style exploration
// Toggle: Super+P or `qs ipc call bar togglePrototype`
// Shows 5 popout variants for visual comparison. Delete when done.
//
// For real blur on the Glass variant, run:
//   hyprctl keyword layerrule blur,golgor-bar-prototype
//   hyprctl keyword layerrule ignorealpha 0.3,golgor-bar-prototype

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:services"

PanelWindow {
    id: root

    readonly property bool showing: Actions.prototypeVisible

    visible: showing

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: "golgor-bar-prototype"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    HyprlandFocusGrab {
        active: root.showing
        windows: [root, bar]
        onCleared: Actions.prototypeVisible = false
    }

    // Scrim
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.showing ? 0.35 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Actions.prototypeVisible = false
    }

    // ========================
    // VARIANTS — right side
    // ========================

    Column {
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

        // -------------------------------------------
        // 1. CHAMFERED CLASSIC
        // Flat top (connects to bar), rounded bottom
        // Animation: slide down
        // -------------------------------------------
        Item {
            id: v1
            width: 240
            height: v1bg.height

            opacity: root.showing ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            Translate {
                id: v1translate
                y: root.showing ? 0 : -60
                Behavior on y { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
            }
            transform: v1translate

            Rectangle {
                id: v1bg
                width: parent.width
                height: v1content.implicitHeight + 32
                color: Theme.background

                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: 20
                bottomRightRadius: 20

                ColumnLayout {
                    id: v1content
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text { text: "1 · Chamfered Classic"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
                    Text { text: "Flat top, rounded bottom (r20).\nConnects seamlessly to bar edge."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
                    Text { text: "Animation: slide down"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.08 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.10 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.06 }
                }
            }
        }

        // -------------------------------------------
        // 2. ORGANIC CURVES
        // Asymmetric per-corner radii — soft, playful
        // Animation: scale + fade with overshoot
        // -------------------------------------------
        Item {
            id: v2
            width: 240
            height: v2bg.height

            opacity: root.showing ? 1 : 0
            scale: root.showing ? 1 : 0.7
            transformOrigin: Item.Center

            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 450; easing.type: Easing.OutBack }
            }

            Rectangle {
                id: v2bg
                width: parent.width
                height: v2content.implicitHeight + 32
                color: Theme.background

                border.width: 1
                border.color: Theme.accent
                opacity: parent.opacity > 0 ? 1 : 0

                topLeftRadius: 4
                topRightRadius: 24
                bottomLeftRadius: 24
                bottomRightRadius: 8

                ColumnLayout {
                    id: v2content
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text { text: "2 · Organic Curves"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
                    Text { text: "Asymmetric radii (4/24/24/8).\nSoft, playful, distinctive."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
                    Text { text: "Animation: scale with overshoot"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.08 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.10 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.06 }
                }
            }
        }

        // -------------------------------------------
        // 3. NOTCHED
        // Rounded rect with triangular notch pointing up
        // Animation: spring bounce
        // -------------------------------------------
        Item {
            id: v3
            width: 240
            height: v3notch.height + v3bg.height

            opacity: root.showing ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            Translate {
                id: v3translate
                y: root.showing ? 0 : -40
                Behavior on y { SpringAnimation { spring: 3; damping: 0.4; mass: 0.8 } }
            }
            transform: v3translate

            // Notch triangle
            Canvas {
                id: v3notch
                width: 24
                height: 12
                anchors.horizontalCenter: parent.horizontalCenter

                property color bgColor: Theme.background

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.fillStyle = bgColor.toString();
                    ctx.beginPath();
                    ctx.moveTo(0, height);
                    ctx.lineTo(width / 2, 0);
                    ctx.lineTo(width, height);
                    ctx.closePath();
                    ctx.fill();
                }

                onBgColorChanged: requestPaint()
            }

            Rectangle {
                id: v3bg
                anchors.top: v3notch.bottom
                width: parent.width
                height: v3content.implicitHeight + 32
                radius: 12
                color: Theme.background

                ColumnLayout {
                    id: v3content
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text { text: "3 · Notched"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
                    Text { text: "Rounded rect + triangular notch.\nPoints to trigger element."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
                    Text { text: "Animation: spring bounce"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.08 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.10 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.06 }
                }
            }
        }

        // -------------------------------------------
        // 4. GLASS PANEL
        // Semi-transparent bg, thin border, all rounded
        // Animation: smooth fade
        // Blur via Hyprland layerrule (see file header)
        // -------------------------------------------
        Item {
            id: v4
            width: 240
            height: v4bg.height

            opacity: root.showing ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }

            Rectangle {
                id: v4bg
                width: parent.width
                height: v4content.implicitHeight + 32
                radius: 14
                color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.55)

                border.width: 1
                border.color: Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.15)

                ColumnLayout {
                    id: v4content
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text { text: "4 · Glass Panel"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
                    Text { text: "Semi-transparent (55% bg).\nThin border, all corners r14."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
                    Text { text: "Animation: smooth fade"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
                    Text { text: "Enable blur: see file header"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.5 }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.08 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.10 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.06 }
                }
            }
        }

        // -------------------------------------------
        // 5. EDGE SEAMLESS
        // Flat right side (flush with screen edge), rounded left
        // Animation: slide from right
        // -------------------------------------------
        Item {
            id: v5
            width: 240
            height: v5bg.height

            opacity: root.showing ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            Translate {
                id: v5translate
                x: root.showing ? 0 : 120
                Behavior on x { NumberAnimation { duration: 450; easing.type: Easing.OutQuart } }
            }
            transform: v5translate

            Rectangle {
                id: v5bg
                width: parent.width
                height: v5content.implicitHeight + 32
                color: Theme.background

                topLeftRadius: 16
                topRightRadius: 0
                bottomLeftRadius: 16
                bottomRightRadius: 0

                ColumnLayout {
                    id: v5content
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Text { text: "5 · Edge Seamless"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize + 2; font.bold: true }
                    Text { text: "Flat right edge (flush to screen).\nRounded left side (r16)."; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 1; opacity: 0.7 }
                    Text { text: "Animation: slide from right"; color: Theme.foreground; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize - 2; font.italic: true; opacity: 0.4 }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.foreground; opacity: 0.15 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.08 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.10 }
                    Rectangle { Layout.fillWidth: true; height: 12; radius: 4; color: Theme.foreground; opacity: 0.06 }
                }
            }
        }
    }
}
