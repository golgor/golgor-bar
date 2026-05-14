# Singleton service layer for all system state

All system state (theme, time, battery, etc.) lives in `services/` as QML singletons, accessed globally by name (e.g. `Theme.background`). Modules consume services but never own system state themselves. The dependency rule is one-directional: modules → components → services → utils.

This follows Caelestia's pattern where every service uses `pragma Singleton` and is registered in `services/qmldir`. The alternative — passing state as explicit properties through the component tree — makes dependencies visible but becomes unwieldy as the number of services and consumers grows. Singletons trade that visibility for simplicity, which is acceptable in a personal project where the module count stays small.
