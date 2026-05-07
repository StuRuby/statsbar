import SwiftUI

struct CoreGrid: View {
    let coreUsages: [Double]
    private let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(coreUsages.enumerated()), id: \.offset) { index, usage in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Core \(index)").font(.caption2)
                    ProgressView(value: usage / 100)
                }
                .padding(8)
                .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
