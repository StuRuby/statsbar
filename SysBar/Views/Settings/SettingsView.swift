import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        Form {
            Section("Menu Bar") {
                Picker("Display", selection: $settings.menuBarDisplayModeRaw) {
                    Text("Icon Only").tag(AppSettings.MenuBarDisplayMode.iconOnly.rawValue)
                    Text("Icon + Value").tag(AppSettings.MenuBarDisplayMode.iconAndValue.rawValue)
                    Text("Value Only").tag(AppSettings.MenuBarDisplayMode.valueOnly.rawValue)
                }
                Picker("Metric", selection: $settings.menuMetricRaw) {
                    Text("CPU %").tag(AppSettings.MenuMetric.cpu.rawValue)
                    Text("Memory %").tag(AppSettings.MenuMetric.memory.rawValue)
                    Text("Download").tag(AppSettings.MenuMetric.download.rawValue)
                    Text("Upload").tag(AppSettings.MenuMetric.upload.rawValue)
                }
            }

            Section("Units") {
                Picker("Temperature", selection: $settings.temperatureUnitRaw) {
                    Text("°C").tag(AppSettings.TemperatureUnit.celsius.rawValue)
                    Text("°F").tag(AppSettings.TemperatureUnit.fahrenheit.rawValue)
                }
            }
        }
        .padding()
        .frame(width: 420)
    }
}
