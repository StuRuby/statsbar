import Foundation

struct MemorySnapshot {
    var usedBytes: UInt64
    var totalBytes: UInt64
    var wiredBytes: UInt64
    var compressedBytes: UInt64
    var freeBytes: UInt64
    var swapUsedBytes: UInt64
    var topProcesses: [ProcessInfoItem]

    var usagePercent: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(usedBytes) / Double(totalBytes)
    }

    static let empty = MemorySnapshot(usedBytes: 0, totalBytes: 0, wiredBytes: 0, compressedBytes: 0, freeBytes: 0, swapUsedBytes: 0, topProcesses: [])
}
