//
//  ContentView.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showComments = false
    var body: some View {
        NavigationView {
            VStack {
                Text("ARchitect Furniture Comments")
                    .font(.title)
                    .bold()
                    .padding()

                VStack {
                            Button("Show Comments") {
                                showComments.toggle()
                            }
                        }
                        .sheet(isPresented: $showComments) {
                            // iOS 16+ allows us to specify detents for medium, large, etc.
                            CommentSectionView()
                                .presentationDetents([.medium, .large])
                        }
            }
            .navigationTitle("Furniture Post")
        }
    }
}

#Preview {
    ContentView()
}
