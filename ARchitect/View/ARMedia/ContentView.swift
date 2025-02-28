//
//  ContentView.swift
//  ARchitect
//
//  Created by Dhairya Patel on 2/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("ARchitect Furniture Comments")
                    .font(.title)
                    .bold()
                    .padding()

                CommentSectionView()
            }
            .navigationTitle("Furniture Post")
        }
    }
}

#Preview {
    ContentView()
}
