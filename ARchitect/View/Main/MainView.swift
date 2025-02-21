//
//  MainView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct MainView: View {
    @State private var isAuthenticated: Bool = false
    @State private var selectedTab = 0
    
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
		TabView(selection: $selectedTab) {
			FurnitureEntryView()
				.tabItem {
					Image(systemName: selectedTab == 0 ? "camera.circle.fill" : "camera")
					Text("AR Furniture")
				}
				.tag(0)
			
			ARFeedView()
				.tabItem {
					Image(systemName: selectedTab == 1 ? "figure.socialdance.circle" : "figure.socialdance")
					Text("AR Feed")
				}
				.tag(1)
			
			ProfileView()
				.tabItem {
					Image(systemName: selectedTab == 2 ? "person.circle.fill" : "person")
					Text("Profile")
				}
				.tag(2)
			
        }
    }
}

#Preview {
    MainView()
}
