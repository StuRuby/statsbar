import Foundation

enum ByteFormatter {
    static func string(_ bytes: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .binary)
    }
}
