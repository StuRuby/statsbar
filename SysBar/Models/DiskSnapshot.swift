import Foundation

struct DiskVolumeSnapshot: Identifiable {
    var id: String { mountPoint }
    let name: String
    let mountPoint: String
    let usedBytes: UInt64
    let totalBytes: UInt64
}

struct DiskSnapshot {
    var volumes: [DiskVolumeSnapshot]
    var readBytesPerSecond: Double
    var writeBytesPerSecond: Double

    static let empty = DiskSnapshot(volumes: [], readBytesPerSecond: 0, writeBytesPerSecond: 0)
}
