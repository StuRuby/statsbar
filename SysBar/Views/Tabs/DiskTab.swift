import SwiftUI

struct DiskTab: View {
    @EnvironmentObject private var monitor: SystemMonitor
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(monitor.disk.volumes) { volume in
                ProgressRow(title: volume.name, value: Double(volume.usedBytes) / Double(max(1, volume.totalBytes)), detail: "\(ByteFormatter.string(volume.usedBytes)) / \(ByteFormatter.string(volume.totalBytes))")
            }
        }
    }
}
