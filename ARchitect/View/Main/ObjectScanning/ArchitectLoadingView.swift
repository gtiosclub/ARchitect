import SwiftUI

struct ArchitectLoadingView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 12) {
                // "ARchitect" title with clean system font
                Text("ARchitect")
                    .font(.system(size: 32, weight: .semibold, design: .default))
                    .foregroundColor(.blue)

                // Subtle spinner underneath
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
        }
    }
}
