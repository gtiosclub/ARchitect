import SwiftUI

struct ARFeedView: View {
    @State private var feedEntries: [FeedEntry] = FeedStorage.shared.load()

    var body: some View {
        NavigationView {
            List(feedEntries.reversed()) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    if let image = entry.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }

                    Text("Cubes in Scene:")
                        .font(.headline)

                    ForEach(entry.cubes) { cube in
                        Text("• \(cube.colorName) at \(formatted(cube.position))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("AR Feed")
        }
    }

    func formatted(_ position: SIMD3<Float>) -> String {
        String(format: "(%.2f, %.2f, %.2f)", position.x, position.y, position.z)
    }
}
