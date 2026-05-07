# StatsBar / SysBar

A lightweight SwiftUI menu bar monitor for macOS, with a CodexBar-inspired panel layout.

## Implemented

- Menu bar app entry using `MenuBarExtra(.window)`.
- Panel with 7 tabs: Overview, CPU, Memory, Disk, Network, Battery, Sensors.
- Shared `SystemMonitor` aggregation layer with panel-aware refresh cadence.
- Snapshot model set for core modules.
- Reusable UI components (`ProgressRow`, `BigNumber`, `CoreGrid`).
- Basic settings persistence with `@AppStorage`.

## Notes

- CPU/Memory/Network monitors now have native sampling paths on macOS (with non-macOS fallback behavior).
- Disk volumes and battery status now have native sampling paths; CPU/Memory tabs now render top process lists via `proc_listallpids` + `proc_pidinfo` on macOS. Remaining work: true disk read/write counters via IOKit and Intel/Apple Silicon sensor readers.
