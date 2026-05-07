import Foundation

struct CPUSnapshot {
    var usagePercent: Double
    var coreUsages: [Double]
    var frequencyGHz: Double?
    var temperatureCelsius: Double?
    var history: [Double]
    var topProcesses: [ProcessInfoItem]

    static let empty = CPUSnapshot(
        usagePercent: 0,
        coreUsages: [],
        frequencyGHz: nil,
        temperatureCelsius: nil,
        history: [],
        topProcesses: []
    )
}
