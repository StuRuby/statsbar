import Foundation

#if os(macOS)
import Darwin.Mach
#endif

actor MemoryMonitor {
    private let processReader = ProcessReader()
    func sample() async -> MemorySnapshot {
        #if os(macOS)
        let pageSize = vm_kernel_page_size
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else { return .empty }

        let active = UInt64(stats.active_count) * UInt64(pageSize)
        let wired = UInt64(stats.wire_count) * UInt64(pageSize)
        let compressed = UInt64(stats.compressor_page_count) * UInt64(pageSize)
        let free = UInt64(stats.free_count) * UInt64(pageSize)
        let used = active + wired + compressed
        let total = used + free
        let top = processReader.topByMemory(limit: 5)
        return MemorySnapshot(usedBytes: used, totalBytes: total, wiredBytes: wired, compressedBytes: compressed, freeBytes: free, swapUsedBytes: 0, topProcesses: top)
        #else
        let total: UInt64 = 16 * 1024 * 1024 * 1024
        let used: UInt64 = 8 * 1024 * 1024 * 1024 + UInt64.random(in: 0...(2 * 1024 * 1024 * 1024))
        return MemorySnapshot(usedBytes: used, totalBytes: total, wiredBytes: used / 3, compressedBytes: used / 10, freeBytes: total - used, swapUsedBytes: 0, topProcesses: processReader.topByMemory(limit: 5))
        #endif
    }
}
