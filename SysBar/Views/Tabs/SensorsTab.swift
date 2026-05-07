import SwiftUI

struct SensorsTab: View {
    @EnvironmentObject private var monitor: SystemMonitor
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(monitor.sensors.temperatures.keys.sorted(), id: \.self) { key in
                Text("\(key): \(monitor.sensors.temperatures[key] ?? 0, specifier: "%.1f")°C")
            }
            ForEach(monitor.sensors.fanRPMs.keys.sorted(), id: \.self) { key in
                Text("\(key): \(monitor.sensors.fanRPMs[key] ?? 0) RPM")
            }
        }
    }
}
