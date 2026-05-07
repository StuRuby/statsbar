import SwiftUI

struct TabBar: View {
    @Binding var selected: PanelState.Tab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PanelState.Tab.allCases) { tab in
                    Button(tab.title) { selected = tab }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selected == tab ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(selected == tab ? .white : .secondary)
                        .clipShape(Capsule())
                }
            }
        }
    }
}
