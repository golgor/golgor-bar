pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    // --- Calendar ---
    property bool calendarVisible: false

    // --- Prototype (throwaway — delete when done) ---
    property bool prototypeVisible: false

    function toggleCalendar(): void {
        calendarVisible = !calendarVisible;
    }

    property double _lastPrototypeToggleMs: 0

    function togglePrototype(): void {
        const now = Date.now();
        if (now - _lastPrototypeToggleMs < 250)
            return;

        _lastPrototypeToggleMs = now;
        prototypeVisible = !prototypeVisible;
    }

    function showPrototype(): void {
        prototypeVisible = true;
    }

    function hidePrototype(): void {
        prototypeVisible = false;
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
