import Foundation

struct NetworkSnapshot {
    var interfaceName: String
    var ssid: String?
    var downloadBytesPerSecond: Double
    var uploadBytesPerSecond: Double
    var totalDownloadBytes: UInt64
    var totalUploadBytes: UInt64
    var historyDownload: [Double]
    var historyUpload: [Double]

    static let empty = NetworkSnapshot(interfaceName: "--", ssid: nil, downloadBytesPerSecond: 0, uploadBytesPerSecond: 0, totalDownloadBytes: 0, totalUploadBytes: 0, historyDownload: [], historyUpload: [])
}
