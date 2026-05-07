import Foundation

#if canImport(Darwin)
import Darwin
#endif

actor DiskMonitor {
    #if os(macOS)
    private var previousRead: UInt64 = 0
    private var previousWrite: UInt64 = 0
    private var previousDate = Date()
    #endif

    func sample() async -> DiskSnapshot {
        let volumes = readMountedVolumes()

        #if os(macOS)
        let now = Date()
        let elapsed = max(0.001, now.timeIntervalSince(previousDate))
        let io = readDiskIOTotals()
        let deltaRead = io.read >= previousRead ? io.read - previousRead : 0
        let deltaWrite = io.write >= previousWrite ? io.write - previousWrite : 0
        previousRead = io.read
        previousWrite = io.write
        previousDate = now
        return DiskSnapshot(volumes: volumes, readBytesPerSecond: Double(deltaRead) / elapsed, writeBytesPerSecond: Double(deltaWrite) / elapsed)
        #else
        return DiskSnapshot(volumes: volumes, readBytesPerSecond: 0, writeBytesPerSecond: 0)
        #endif
    }

    private func readMountedVolumes() -> [DiskVolumeSnapshot] {
        let keys: [URLResourceKey] = [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey, .volumeNameKey]
        let urls = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [.skipHiddenVolumes]) ?? []

        return urls.compactMap { url in
            guard let values = try? url.resourceValues(forKeys: Set(keys)),
                  let total = values.volumeTotalCapacity,
                  let available = values.volumeAvailableCapacityForImportantUsage else {
                return nil
            }
            let used = UInt64(max(0, total - available))
            let totalBytes = UInt64(total)
            return DiskVolumeSnapshot(name: values.volumeName ?? url.lastPathComponent, mountPoint: url.path, usedBytes: used, totalBytes: totalBytes)
        }
        .sorted { lhs, rhs in
            if lhs.mountPoint == "/" { return true }
            if rhs.mountPoint == "/" { return false }
            return lhs.name < rhs.name
        }
    }

    #if os(macOS)
    private func readDiskIOTotals() -> (read: UInt64, write: UInt64) {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath: "/"),
              let total = attrs[.systemSize] as? NSNumber,
              let free = attrs[.systemFreeSize] as? NSNumber else {
            return (0, 0)
        }
        // Placeholder approximation until full IOKit media statistics integration.
        let used = max(0, total.uint64Value - free.uint64Value)
        return (used, used / 2)
    }
    #endif
}
