import Foundation

#if os(macOS)
import IOKit.ps
#endif

actor BatteryMonitor {
    func sample() async -> BatterySnapshot {
        #if os(macOS)
        guard let blob = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let list = IOPSCopyPowerSourcesList(blob)?.takeRetainedValue() as? [CFTypeRef],
              let ps = list.first,
              let desc = IOPSGetPowerSourceDescription(blob, ps)?.takeUnretainedValue() as? [String: Any] else {
            return .empty
        }

        let max = desc[kIOPSMaxCapacityKey as String] as? Double ?? 0
        let current = desc[kIOPSCurrentCapacityKey as String] as? Double ?? 0
        let state = (desc[kIOPSPowerSourceStateKey as String] as? String) ?? "Unknown"
        let isCharging = (desc[kIOPSIsChargingKey as String] as? Bool) ?? false
        let mins = (desc[kIOPSTimeToEmptyKey as String] as? Int) ?? -1

        let percent = max > 0 ? current / max : 0
        let stateText = isCharging ? "Charging" : state
        let timeText = mins > 0 ? "\(mins / 60)h \(mins % 60)m" : "--"
        return BatterySnapshot(isAvailable: true, percent: percent, stateText: stateText, timeRemainingText: timeText)
        #else
        return BatterySnapshot(isAvailable: false, percent: 0, stateText: "Unsupported", timeRemainingText: "--")
        #endif
    }
}
