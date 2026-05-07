import SwiftUI

struct NetworkTab: View {
    @EnvironmentObject private var monitor: SystemMonitor
    var body: some View {
        VStack(alignment: .leading) {
            BigNumber(value: RateFormatter.string(bytesPerSecond: monitor.network.downloadBytesPerSecond), title: "Download")
            Text("Upload: \(RateFormatter.string(bytesPerSecond: monitor.network.uploadBytesPerSecond))")
        }
    }
}
