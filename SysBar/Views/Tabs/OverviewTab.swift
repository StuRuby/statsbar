import SwiftUI

struct OverviewTab: View {
    @EnvironmentObject private var monitor: SystemMonitor

    var body: some View {
        VStack(spacing: 12) {
            ProgressRow(title: "CPU", value: monitor.cpu.usagePercent / 100, detail: "\(Int(monitor.cpu.usagePercent))%")
            ProgressRow(title: "Memory", value: monitor.memory.usagePercent, detail: "\(ByteFormatter.string(monitor.memory.usedBytes)) / \(ByteFormatter.string(monitor.memory.totalBytes))")
            ProgressRow(title: "Disk", value: diskRatio, detail: monitor.disk.volumes.first.map { "\(ByteFormatter.string($0.usedBytes)) / \(ByteFormatter.string($0.totalBytes))" })
            Text("Network ↓ \(RateFormatter.string(bytesPerSecond: monitor.network.downloadBytesPerSecond))  ↑ \(RateFormatter.string(bytesPerSecond: monitor.network.uploadBytesPerSecond))")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var diskRatio: Double {
        guard let d = monitor.disk.volumes.first, d.totalBytes > 0 else { return 0 }
        return Double(d.usedBytes) / Double(d.totalBytes)
    }
}
