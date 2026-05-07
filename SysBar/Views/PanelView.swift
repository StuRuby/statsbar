import SwiftUI

struct PanelView: View {
    @EnvironmentObject private var monitor: SystemMonitor
    @StateObject private var panelState = PanelState()

    var body: some View {
        VStack(spacing: 12) {
            TabBar(selected: $panelState.selectedTab)
            ScrollView {
                selectedTabView
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 520)
            Divider()
            HStack {
                Button("↻ Refresh") { monitor.refreshNow() }
                Spacer()
                Button("⚙ Settings…") { NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil) }
                Button("Quit") { NSApp.terminate(nil) }
            }
            .font(.footnote)
        }
        .padding(16)
        .onAppear { monitor.panelDidAppear() }
        .onDisappear { monitor.panelDidDisappear() }
    }

    @ViewBuilder
    private var selectedTabView: some View {
        switch panelState.selectedTab {
        case .overview: OverviewTab()
        case .cpu: CPUTab()
        case .memory: MemoryTab()
        case .disk: DiskTab()
        case .network: NetworkTab()
        case .battery: BatteryTab()
        case .sensors: SensorsTab()
        }
    }
}
