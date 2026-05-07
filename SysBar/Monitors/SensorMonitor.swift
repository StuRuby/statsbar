import Foundation

protocol SensorReader {
    func read() -> SensorSnapshot
}

struct FallbackSensorReader: SensorReader {
    func read() -> SensorSnapshot {
        SensorSnapshot(temperatures: [:], fanRPMs: [:], voltages: [:])
    }
}

actor SensorMonitor {
    private let reader: SensorReader

    init(reader: SensorReader = FallbackSensorReader()) {
        self.reader = reader
    }

    func sample() async -> SensorSnapshot {
        reader.read()
    }
}
