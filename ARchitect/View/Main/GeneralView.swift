import SwiftUI

enum RecentMode {
    case box
    case sofa
}

struct GeneralView: View {
    @State private var recentMode: RecentMode = .box

    var body: some View {
        NavigationStack {
            if recentMode == .box {
                ProjectsView(recentMode: $recentMode)
            } else {
                FurnitureLibraryView(recentMode: $recentMode)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
