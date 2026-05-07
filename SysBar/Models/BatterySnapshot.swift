import Foundation

struct BatterySnapshot {
    var isAvailable: Bool
    var percent: Double
    var stateText: String
    var timeRemainingText: String

    static let empty = BatterySnapshot(isAvailable: false, percent: 0, stateText: "Unknown", timeRemainingText: "--")
}
