import Foundation

#if os(macOS)
import Darwin
import libproc
#endif

struct ProcessReader {
    func topByCPU(limit: Int) -> [ProcessInfoItem] {
        #if os(macOS)
        return readProcesses(limit: limit, sort: { $0.cpuPercent > $1.cpuPercent })
        #else
        return []
        #endif
    }

    func topByMemory(limit: Int) -> [ProcessInfoItem] {
        #if os(macOS)
        return readProcesses(limit: limit, sort: { $0.memoryBytes > $1.memoryBytes })
        #else
        return []
        #endif
    }

    #if os(macOS)
    private func readProcesses(limit: Int, sort: (ProcessInfoItem, ProcessInfoItem) -> Bool) -> [ProcessInfoItem] {
        let count = proc_listallpids(nil, 0)
        guard count > 0 else { return [] }

        let capacity = Int(count)
        var pids = [pid_t](repeating: 0, count: capacity)
        let byteCount = Int32(capacity * MemoryLayout<pid_t>.size)
        let filled = proc_listallpids(&pids, byteCount)
        guard filled > 0 else { return [] }

        let valid = pids.prefix(Int(filled))
        var output: [ProcessInfoItem] = []
        output.reserveCapacity(limit * 2)

        for pid in valid where pid > 0 {
            var taskInfo = proc_taskinfo()
            let size = proc_pidinfo(pid, PROC_PIDTASKINFO, 0, &taskInfo, Int32(MemoryLayout<proc_taskinfo>.size))
            guard size == MemoryLayout<proc_taskinfo>.size else { continue }

            var nameBuf = [CChar](repeating: 0, count: Int(MAXCOMLEN + 1))
            proc_name(pid, &nameBuf, UInt32(nameBuf.count))
            let name = String(cString: nameBuf)

            let cpu = min(100.0, (Double(taskInfo.pti_total_user) + Double(taskInfo.pti_total_system)) / 1_000_000_000.0)
            let memory = UInt64(taskInfo.pti_resident_size)
            output.append(ProcessInfoItem(id: pid, name: name.isEmpty ? "pid_\(pid)" : name, cpuPercent: cpu, memoryBytes: memory))
        }

        return output.sorted(by: sort).prefix(limit).map { $0 }
    }
    #endif
}
