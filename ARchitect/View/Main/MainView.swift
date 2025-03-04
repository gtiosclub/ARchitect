
import SwiftUI

struct MainView: View {
    @State private var isAuthenticated: Bool = false
    @State private var showProjectPage: Bool = false
    
    var body: some View {
        tabController
            .sheet(isPresented: Binding(get: {
                !isAuthenticated
            }, set: { _ in })) {
                AuthenticationView(isAuthenticated: $isAuthenticated)
                    .interactiveDismissDisabled(true)
            }
        VStack {
                    Spacer()
                    
                    Button(action: {
                        showProjectPage = true
                    }) {
                        Text("Go to Projects")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .fullScreenCover(isPresented: $showProjectPage) {
                        FurniturePageView()
                    }
                }
    }
    
    var tabController: some View {
        TabView {
            Tab("AR Furniture", systemImage: "camera.circle.fill") {
                FurnitureEntryView()
            }
            
            Tab("AR Feed", systemImage: "figure.socialdance.circle") {
                ARFeedView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

