import Foundation

final class PanelState: ObservableObject {
    enum Tab: String, CaseIterable, Identifiable {
        case overview, cpu, memory, disk, network, battery, sensors
        var id: String { rawValue }
        var title: String {
            switch self {
            case .overview: return "Overview"
            case .cpu: return "CPU"
            case .memory: return "Memory"
            case .disk: return "Disk"
            case .network: return "Network"
            case .battery: return "Battery"
            case .sensors: return "Sensors"
            }
        }
    }

    @Published var selectedTab: Tab = .overview
}
