//
//  MainView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct MainView: View {
    @State private var isAuthenticated: Bool = false
    
    
    var body: some View {
        tabController
            .sheet(isPresented: Binding(get: {
                !isAuthenticated
            }, set: { _ in })) {
                AuthenticationView(isAuthenticated: $isAuthenticated)
                    .interactiveDismissDisabled(true)
            }
    }
    
    var tabController: some View {
        TabView {
            Tab("AR Furniture", systemImage: "camera.circle.fill") {
                FurnitureEntryView()
            }
            
            Tab("AR Feed", systemImage: "figure.socialdance.circle") {
                ARMediaView()
            }
        }
    }
}

#Preview {
    MainView()
}
