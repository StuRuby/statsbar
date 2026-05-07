import Foundation

struct SensorSnapshot {
    var temperatures: [String: Double]
    var fanRPMs: [String: Int]
    var voltages: [String: Double]

    static let empty = SensorSnapshot(temperatures: [:], fanRPMs: [:], voltages: [:])
}
