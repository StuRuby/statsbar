import SwiftUI

struct MenuBarLabel: View {
    @EnvironmentObject private var monitor: SystemMonitor
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        let value = formattedValue
        HStack(spacing: 4) {
            if settings.menuBarDisplayMode != .valueOnly {
                Image(systemName: "cpu")
            }
            if settings.menuBarDisplayMode != .iconOnly {
                Text(value)
                    .monospacedDigit()
            }
        }
    }

    private var formattedValue: String {
        switch settings.menuMetric {
        case .cpu:
            return "\(Int(monitor.cpu.usagePercent))%"
        case .memory:
            guard monitor.memory.totalBytes > 0 else { return "--" }
            let ratio = Double(monitor.memory.usedBytes) / Double(monitor.memory.totalBytes)
            return "\(Int(ratio * 100))%"
        case .download:
            return RateFormatter.string(bytesPerSecond: monitor.network.downloadBytesPerSecond)
        case .upload:
            return RateFormatter.string(bytesPerSecond: monitor.network.uploadBytesPerSecond)
        }
    }
}
