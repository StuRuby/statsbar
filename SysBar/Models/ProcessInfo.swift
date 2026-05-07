import Foundation

struct ProcessInfoItem: Identifiable {
    let id: Int32
    let name: String
    let cpuPercent: Double
    let memoryBytes: UInt64
}
