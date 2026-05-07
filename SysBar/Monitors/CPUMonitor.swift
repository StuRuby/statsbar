import Foundation

#if os(macOS)
import Darwin.Mach
#endif

actor CPUMonitor {
    private let processReader = ProcessReader()
    private var history = RingBuffer<Double>(capacity: 60)

    #if os(macOS)
    private var previousTicks: [UInt32] = []
    #endif

    func sample() async -> CPUSnapshot {
        #if os(macOS)
        let coreUsages = readCoreUsages()
        let usage = coreUsages.isEmpty ? 0 : coreUsages.reduce(0, +) / Double(coreUsages.count)
        #else
        let usage = Double.random(in: 12...68)
        let coreUsages = (0..<8).map { _ in min(100, max(0, usage + Double.random(in: -15...15))) }
        #endif

        history.append(usage)
        let top = processReader.topByCPU(limit: 5)
        return CPUSnapshot(usagePercent: usage, coreUsages: coreUsages, frequencyGHz: nil, temperatureCelsius: nil, history: history.elements, topProcesses: top)
    }

    #if os(macOS)
    private func readCoreUsages() -> [Double] {
        var cpuInfo: processor_info_array_t?
        var cpuInfoCount: mach_msg_type_number_t = 0
        var cpuCount: natural_t = 0

        let result = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &cpuCount, &cpuInfo, &cpuInfoCount)
        guard result == KERN_SUCCESS, let cpuInfo else { return [] }
        defer {
            let count = vm_size_t(cpuInfoCount) * vm_size_t(MemoryLayout<integer_t>.stride)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: cpuInfo), count)
        }

        let ticks = Array(UnsafeBufferPointer(start: cpuInfo, count: Int(cpuInfoCount))).map(UInt32.init)
        guard previousTicks.count == ticks.count else {
            previousTicks = ticks
            return Array(repeating: 0, count: Int(cpuCount))
        }

        var usages: [Double] = []
        for index in 0..<Int(cpuCount) {
            let base = index * Int(CPU_STATE_MAX)
            let user = ticks[base + Int(CPU_STATE_USER)] - previousTicks[base + Int(CPU_STATE_USER)]
            let system = ticks[base + Int(CPU_STATE_SYSTEM)] - previousTicks[base + Int(CPU_STATE_SYSTEM)]
            let idle = ticks[base + Int(CPU_STATE_IDLE)] - previousTicks[base + Int(CPU_STATE_IDLE)]
            let nice = ticks[base + Int(CPU_STATE_NICE)] - previousTicks[base + Int(CPU_STATE_NICE)]
            let total = user + system + idle + nice
            let active = user + system + nice
            usages.append(total > 0 ? (Double(active) / Double(total)) * 100 : 0)
        }
        previousTicks = ticks
        return usages
    }
    #endif
}
