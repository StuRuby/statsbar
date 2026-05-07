import SwiftUI

@main
struct SysBarApp: App {
    @StateObject private var monitor = SystemMonitor.shared
    @StateObject private var settings = AppSettings.shared

    var body: some Scene {
        MenuBarExtra {
            PanelView()
                .environmentObject(monitor)
                .environmentObject(settings)
                .frame(width: 380)
        } label: {
            MenuBarLabel()
                .environmentObject(monitor)
                .environmentObject(settings)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(settings)
        }
    }
}
