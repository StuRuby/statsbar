import SwiftUI

struct ProcessRow: View {
    let process: ProcessInfoItem
    let mode: Mode

    enum Mode { case cpu, memory }

    var body: some View {
        HStack {
            Text(process.name).lineLimit(1)
            Spacer()
            switch mode {
            case .cpu:
                Text(String(format: "%.1f%%", process.cpuPercent)).monospacedDigit().foregroundStyle(.secondary)
            case .memory:
                Text(ByteFormatter.string(process.memoryBytes)).monospacedDigit().foregroundStyle(.secondary)
            }
        }
        .font(.caption)
    }
}
