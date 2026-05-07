import Foundation

enum Logger {
    static func info(_ message: String) {
        #if DEBUG
        print("[SysBar] \(message)")
        #endif
    }
}
