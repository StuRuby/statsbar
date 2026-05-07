import SwiftUI

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    enum MenuBarDisplayMode: String, CaseIterable { case iconOnly, iconAndValue, valueOnly }
    enum MenuMetric: String, CaseIterable { case cpu, memory, download, upload }
    enum TemperatureUnit: String, CaseIterable { case celsius, fahrenheit }

    @AppStorage("menuBarDisplayMode") var menuBarDisplayModeRaw = MenuBarDisplayMode.iconAndValue.rawValue
    @AppStorage("menuMetric") var menuMetricRaw = MenuMetric.cpu.rawValue
    @AppStorage("temperatureUnit") var temperatureUnitRaw = TemperatureUnit.celsius.rawValue

    var menuBarDisplayMode: MenuBarDisplayMode { MenuBarDisplayMode(rawValue: menuBarDisplayModeRaw) ?? .iconAndValue }
    var menuMetric: MenuMetric { MenuMetric(rawValue: menuMetricRaw) ?? .cpu }
    var temperatureUnit: TemperatureUnit { TemperatureUnit(rawValue: temperatureUnitRaw) ?? .celsius }
}
