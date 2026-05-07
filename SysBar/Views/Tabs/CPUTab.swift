import SwiftUI

struct CPUTab: View {
    @EnvironmentObject private var monitor: SystemMonitor

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            BigNumber(value: "\(Int(monitor.cpu.usagePercent))%", title: "CPU Usage")
            ProgressRow(title: "Total", value: monitor.cpu.usagePercent / 100, detail: nil)
            CoreGrid(coreUsages: monitor.cpu.coreUsages)

            if !monitor.cpu.topProcesses.isEmpty {
                Text("Top Processes").font(.caption).foregroundStyle(.secondary)
                ForEach(monitor.cpu.topProcesses) { process in
                    ProcessRow(process: process, mode: .cpu)
                }
            }
        }
    }
}
