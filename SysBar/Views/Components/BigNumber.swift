import SwiftUI

struct BigNumber: View {
    let value: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.system(size: 42, weight: .semibold, design: .rounded)).monospacedDigit()
        }
    }
}
