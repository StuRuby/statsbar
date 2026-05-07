import Foundation

enum RateFormatter {
    static func string(bytesPerSecond: Double) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(bytesPerSecond), countStyle: .binary) + "/s"
    }
}
