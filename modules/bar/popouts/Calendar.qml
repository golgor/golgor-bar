import QtQuick
import QtQuick.Layouts
import "root:services"
import "root:utils"

// TODO: Implement as a proper Quickshell PopupWindow anchored to the clock
// For now, this is the structural placeholder for the calendar popout
Item {
    id: root

    required property Item anchor
    property bool showing: false
    visible: showing
    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()

    function toggle(): void {
        showing = !showing;
    }

    function close(): void {
        showing = false;
    }

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

    // Calendar grid data
    readonly property var days: DateUtils.monthGrid(currentYear, currentMonth)
    readonly property var monthName: new Date(currentYear, currentMonth).toLocaleDateString(Qt.locale(), "MMMM yyyy")

    // TODO: Build out the visual calendar grid
    // - Month/year header with navigation arrows
    // - Day-of-week header row (Mo Tu We Th Fr Sa Su)
    // - Week number column on the left
    // - 6x7 day grid with today highlighted
    // - Keyboard navigation (arrows to navigate months, Escape to close)
    // - Organic chamfered popout shape anchored to bar
}
