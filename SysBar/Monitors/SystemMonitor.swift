import Foundation

@MainActor
final class SystemMonitor: ObservableObject {
    static let shared = SystemMonitor()

    @Published var cpu = CPUSnapshot.empty
    @Published var memory = MemorySnapshot.empty
    @Published var disk = DiskSnapshot.empty
    @Published var network = NetworkSnapshot.empty
    @Published var battery = BatterySnapshot.empty
    @Published var sensors = SensorSnapshot.empty

    private var timer: Timer?

    private let cpuMonitor = CPUMonitor()
    private let memoryMonitor = MemoryMonitor()
    private let diskMonitor = DiskMonitor()
    private let networkMonitor = NetworkMonitor()
    private let batteryMonitor = BatteryMonitor()
    private let sensorMonitor = SensorMonitor()

    private init() {
        start()
    }

    func start() {
        scheduleTimer(interval: 5)
    }

    func panelDidAppear() {
        scheduleTimer(interval: 1)
        tick()
    }

    func panelDidDisappear() {
        scheduleTimer(interval: 5)
    }

    func refreshNow() {
        tick()
    }

    private func scheduleTimer(interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func tick() {
        Task.detached(priority: .utility) {
            let cpu = await self.cpuMonitor.sample()
            let memory = await self.memoryMonitor.sample()
            let disk = await self.diskMonitor.sample()
            let network = await self.networkMonitor.sample()
            let battery = await self.batteryMonitor.sample()
            let sensors = await self.sensorMonitor.sample()

            await MainActor.run {
                self.cpu = cpu
                self.memory = memory
                self.disk = disk
                self.network = network
                self.battery = battery
                self.sensors = sensors
            }
        }
    }
}
