import SwiftUI

struct BatteryTab: View {
    @EnvironmentObject private var monitor: SystemMonitor
    var body: some View {
        if monitor.battery.isAvailable {
            ProgressRow(title: monitor.battery.stateText, value: monitor.battery.percent, detail: "\(Int(monitor.battery.percent * 100))% • \(monitor.battery.timeRemainingText)")
        } else {
            Text("No battery detected")
        }
    }
}
