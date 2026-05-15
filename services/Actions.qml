pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    // --- Calendar ---
    property bool calendarVisible: false

    function toggleCalendar(): void {
        calendarVisible = !calendarVisible;
    }

    // --- Launchers ---
    function launchBluetooth(): void {
        _bluetoothProc.running = true;
    }

    function launchWifi(): void {
        _wifiProc.running = true;
    }

    function launchAudio(): void {
        _audioProc.running = true;
    }

    function launchBtop(): void {
        _btopProc.running = true;
    }

    // Private process instances
    property Process _bluetoothProc: Process {
        command: ["sh", "-lc", "omarchy launch bluetooth"]
    }

    property Process _wifiProc: Process {
        command: ["sh", "-lc", "omarchy launch wifi"]
    }

    property Process _audioProc: Process {
        command: ["sh", "-lc", "omarchy launch audio"]
    }

    property Process _btopProc: Process {
        command: ["sh", "-lc", "omarchy launch or focus tui btop"]
    }
}
