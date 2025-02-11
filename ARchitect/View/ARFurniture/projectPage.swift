//
//  SwiftUIView.swift
//  ARchitect
//
//  Created by Congyan Li on 2025/2/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TopBarView()
            
            SearchBarView()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<2) { _ in
                        CardView()
                    }
                }
                .padding()
            }
            
        }
    }
}


struct TopBarView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading) {
                Text("User Name")
                    .font(.caption)
                    .padding(5)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(5)
                
            }
            
            Spacer()
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray.opacity(0.3))
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding()
    }
}


struct SearchBarView: View {
    @State private var searchText: String = ""
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                            .frame(height: 36)
                            .foregroundColor(.gray.opacity(0.3))
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)

                                    TextField("Search...", text: $searchText)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)

                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            )
            
            
            Button(action: {
            }) {
                Circle()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                    .overlay(
                        Image(systemName: "line.horizontal.3.decrease")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    )
            }
        }
        .padding(.horizontal)
    }
}


struct CardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("tag")
                    .font(.caption)
                    .padding(5)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(5)
                
                Text("tag")
                    .font(.caption)
                    .padding(5)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(5)
                
                Spacer()
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray.opacity(0.3))
            }
            
            Spacer()
            
            Text("Furniture Project Name")
                .font(.caption)
                .padding(5)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(5)
            
        }
        .padding()
        .frame(height: 200)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
