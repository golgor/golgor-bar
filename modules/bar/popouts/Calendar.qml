pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:services"
import "root:utils"

PanelWindow {
    id: root

    property bool showing: false
    visible: showing

    // Full-screen transparent overlay — content is positioned inside
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: "golgor-bar-calendar"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    // Only the calendar area is interactive, rest passes through
    mask: Region {
        x: calendarBg.x
        y: bar.implicitHeight
        width: calendarBg.width
        height: calendarBg.height - 1
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root, bar]
        active: root.showing
        onCleared: root.showing = false
    }

    function toggle(): void {
        showing = !showing;
    }

    function close(): void {
        showing = false;
    }

    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()

    readonly property var days: DateUtils.monthGrid(currentYear, currentMonth)
    readonly property date today: new Date()

    function previousMonth(): void {
        if (currentMonth === 0) {
            currentMonth = 11;
            currentYear--;
        } else {
            currentMonth--;
        }
    }

    function nextMonth(): void {
        if (currentMonth === 11) {
            currentMonth = 0;
            currentYear++;
        } else {
            currentMonth++;
        }
    }

    function goToToday(): void {
        const now = new Date();
        currentMonth = now.getMonth();
        currentYear = now.getFullYear();
    }

    // Calendar background — positioned directly under the bar, centered
    // Overlaps bar by 1px for seamless connection
    Rectangle {
        id: calendarBg

        x: (parent.width - width) / 2
        y: bar.implicitHeight - 1
        width: content.implicitWidth + 32
        height: content.implicitHeight + 32 + 1
        color: Theme.background

        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: 12
        bottomRightRadius: 12

        ColumnLayout {
            id: content

            anchors.centerIn: parent
            spacing: 8

            // Month/year header with navigation
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "◀"
                    color: Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    opacity: 0.7

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.previousMonth()
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: new Date(root.currentYear, root.currentMonth).toLocaleDateString(Qt.locale(), "MMMM yyyy")
                    color: Theme.accent
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 2
                    font.bold: true
                    font.capitalization: Font.Capitalize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.goToToday()
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "▶"
                    color: Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    opacity: 0.7

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.nextMonth()
                    }
                }
            }

            // Day-of-week header (Wk Mo Tu We Th Fr Sa Su)
            GridLayout {
                id: headerGrid

                columns: 8
                rowSpacing: 4
                columnSpacing: 4
                Layout.fillWidth: true

                // Week column header
                Text {
                    text: "Wk"
                    color: Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                    font.bold: true
                    opacity: 0.5
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: 28
                }

                Repeater {
                    model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

                    Text {
                        required property string modelData

                        text: modelData
                        color: (modelData === "Sa" || modelData === "Su") ? Theme.accent : Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                        font.bold: true
                        opacity: 0.7
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 28
                    }
                }
            }

            // Calendar grid: one row per week
            Repeater {
                id: weekRepeater

                model: 6

                RowLayout {
                    id: weekRow

                    required property int index

                    readonly property date firstDayOfWeek: root.days[index * 7]
                    readonly property int weekNum: DateUtils.weekNumber(firstDayOfWeek)

                    spacing: 4
                    Layout.fillWidth: true

                    // Week number
                    Text {
                        text: weekRow.weekNum
                        color: Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                        opacity: 0.4
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 28
                    }

                    // 7 day cells
                    Repeater {
                        model: 7

                        delegate: Item {
                            id: dayCell

                            required property int index

                            readonly property date cellDate: root.days[weekRow.index * 7 + index]
                            readonly property bool isCurrentMonth: cellDate.getMonth() === root.currentMonth
                            readonly property bool isToday: cellDate.getFullYear() === root.today.getFullYear()
                                && cellDate.getMonth() === root.today.getMonth()
                                && cellDate.getDate() === root.today.getDate()
                            readonly property bool isWeekend: index >= 5

                            Layout.preferredWidth: 28
                            Layout.preferredHeight: 28

                            Rectangle {
                                anchors.centerIn: parent
                                width: 26
                                height: 26
                                radius: 13
                                color: dayCell.isToday ? Theme.accent : "transparent"
                            }

                            Text {
                                anchors.centerIn: parent
                                text: dayCell.cellDate.getDate()
                                color: {
                                    if (dayCell.isToday)
                                        return Theme.background;
                                    if (!dayCell.isCurrentMonth)
                                        return Theme.foreground;
                                    if (dayCell.isWeekend)
                                        return Theme.accent;
                                    return Theme.foreground;
                                }
                                opacity: dayCell.isCurrentMonth ? 1.0 : 0.3
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize
                                font.bold: dayCell.isToday
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
