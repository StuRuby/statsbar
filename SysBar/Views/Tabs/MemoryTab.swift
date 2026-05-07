import SwiftUI

struct MemoryTab: View {
    @EnvironmentObject private var monitor: SystemMonitor

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProgressRow(title: "Memory", value: monitor.memory.usagePercent, detail: "\(ByteFormatter.string(monitor.memory.usedBytes)) / \(ByteFormatter.string(monitor.memory.totalBytes))")

            if !monitor.memory.topProcesses.isEmpty {
                Text("Top Processes").font(.caption).foregroundStyle(.secondary)
                ForEach(monitor.memory.topProcesses) { process in
                    ProcessRow(process: process, mode: .memory)
                }
            }
        }
    }
}
