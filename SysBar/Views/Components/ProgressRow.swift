import SwiftUI

struct ProgressRow: View {
    let title: String
    let value: Double
    let detail: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                if let detail { Text(detail).font(.caption).monospacedDigit().foregroundStyle(.secondary) }
            }
            ProgressView(value: max(0, min(1, value))).tint(value > 0.9 ? .red : (value > 0.7 ? .orange : .accentColor))
        }
    }
}
