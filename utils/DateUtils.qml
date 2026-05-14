pragma Singleton

import QtQuick

QtObject {
    // Returns ISO 8601 week number for a given date
    function weekNumber(date: date): int {
        const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
        // Set to nearest Thursday (current date + 4 - current day number, with Sunday as 7)
        d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
        // Get first day of year
        const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
        // Calculate full weeks between yearStart and nearest Thursday
        return Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
    }

    // Returns the first day of the week (Monday) for a given date
    function startOfWeek(date: date): date {
        const d = new Date(date);
        const day = d.getDay();
        const diff = d.getDate() - day + (day === 0 ? -6 : 1);
        d.setDate(diff);
        return d;
    }

    // Returns all dates in a calendar month grid (includes leading/trailing days to fill weeks)
    function monthGrid(year: int, month: int): list<var> {
        const firstOfMonth = new Date(year, month, 1);
        // Monday-based: 0=Mon, 6=Sun
        let startDay = firstOfMonth.getDay() - 1;
        if (startDay < 0) startDay = 6;

        const gridStart = new Date(year, month, 1 - startDay);
        const days = [];

        for (let i = 0; i < 42; i++) {
            const d = new Date(gridStart);
            d.setDate(gridStart.getDate() + i);
            days.push(d);
        }

        return days;
    }
}
