import Foundation

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

actor NetworkMonitor {
    private var downHistory = RingBuffer<Double>(capacity: 60)
    private var upHistory = RingBuffer<Double>(capacity: 60)
    private var previousIn: UInt64 = 0
    private var previousOut: UInt64 = 0
    private var previousDate = Date()
    private var totalDown: UInt64 = 0
    private var totalUp: UInt64 = 0

    func sample() async -> NetworkSnapshot {
        let now = Date()
        let elapsed = max(0.001, now.timeIntervalSince(previousDate))
        let counters = readNetworkCounters()

        let deltaIn = counters.inBytes >= previousIn ? counters.inBytes - previousIn : 0
        let deltaOut = counters.outBytes >= previousOut ? counters.outBytes - previousOut : 0

        let down = Double(deltaIn) / elapsed
        let up = Double(deltaOut) / elapsed

        downHistory.append(down)
        upHistory.append(up)
        totalDown += deltaIn
        totalUp += deltaOut
        previousIn = counters.inBytes
        previousOut = counters.outBytes
        previousDate = now

        return NetworkSnapshot(interfaceName: counters.primaryName, ssid: nil, downloadBytesPerSecond: down, uploadBytesPerSecond: up, totalDownloadBytes: totalDown, totalUploadBytes: totalUp, historyDownload: downHistory.elements, historyUpload: upHistory.elements)
    }

    private func readNetworkCounters() -> (inBytes: UInt64, outBytes: UInt64, primaryName: String) {
        var addrs: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&addrs) == 0, let first = addrs else { return (0, 0, "--") }
        defer { freeifaddrs(addrs) }

        var ptr: UnsafeMutablePointer<ifaddrs>? = first
        var totalIn: UInt64 = 0
        var totalOut: UInt64 = 0
        var primary = "--"

        while let current = ptr {
            let flags = Int32(current.pointee.ifa_flags)
            let isUp = (flags & IFF_UP) != 0
            let isLoopback = (flags & IFF_LOOPBACK) != 0

            #if canImport(Darwin)
            if isUp && !isLoopback,
               let data = current.pointee.ifa_data?.assumingMemoryBound(to: if_data.self) {
                totalIn += UInt64(data.pointee.ifi_ibytes)
                totalOut += UInt64(data.pointee.ifi_obytes)
                if primary == "--", let name = current.pointee.ifa_name {
                    primary = String(cString: name)
                }
            }
            #endif

            ptr = current.pointee.ifa_next
        }

        return (totalIn, totalOut, primary)
    }
}
