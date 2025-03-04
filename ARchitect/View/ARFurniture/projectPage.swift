//
//  SwiftUIView.swift
//  ARchitect
//
//  Created by Congyan Li on 2025/3/3.
//

import SwiftUI

struct ProjectView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Projects"
    @State private var selectedFilter = ""

    let categories = ["Projects", "Furniture"]
    let selections = ["All Projects", "Favorites", "A-Z", "Private", "Public", "Modern"]
    
    let img_url = "project_sample"
    let projects: [Project]

    init() {
        self.projects = [
            Project(name: "Minimalism", image: img_url, tags: ["Minimalistic"]),
            Project(name: "Bedroom", image: img_url, tags: ["Modern", "Sunlit"]),
            Project(name: "Office", image: img_url, tags: ["Old Gothic", "Mono"]),
            Project(name: "Living Room", image: img_url, tags: ["Modern"]),
            Project(name: "Sage Bedroom", image: img_url, tags: ["Nature", "Green"]),
            Project(name: "Sunlit Bedroom", image: img_url, tags: ["Minimalistic"]),
        ]
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    // Search bar
                    HStack {
                        Text("Home")
                            .font(.headline)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)

                    // Category selection
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .padding(.horizontal, geometry.size.width * 0.03) // 3vw
                                    .padding(.vertical, geometry.size.height * 0.005) // 0.5vh
                                    .background(selectedCategory == category ? Color.green : Color.clear)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.02) // 2vw
                    .padding(.vertical, geometry.size.height * 0.01) // 1vh
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)

                    // Recent Projects
                    Text("Recent")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: geometry.size.width * 0.02) { // 2vw
                            ForEach(projects, id: \.self) { project in
                                ProjectCard(project: project, geometry: geometry)
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: geometry.size.height * 0.3) // 30vh
                    }
                    
                    // Projects Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: geometry.size.width * 0.02) { // 2vw
                            ForEach(selections, id: \.self) { selection in
                                Button(action: { selectedFilter = selection }) {
                                    Text(selection)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(geometry.size.width * 0.02) // 2vw
                                }
                                .background(selectedFilter == selection ? Color.gray.opacity(0.2) : Color.clear)
                                .cornerRadius(20)
                            }
                        }
                        .frame(height: geometry.size.height * 0.06) // 6vh
                    }

                    Spacer()
                    
                    // Filtered Projects
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: geometry.size.height * 0.02) { // 2vh
                            ForEach(projects, id: \.self) { project in
                                ProjectCard(project: project, geometry: geometry)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// Project Card View
struct ProjectCard: View {
    let project: Project
    let geometry: GeometryProxy  // Pass GeometryReader for responsive sizing

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.3) // 40vw, 30vh
                .clipped()

            Image(project.image) // Use image from assets
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.3) // 40vw, 30vh
                .clipped()

            VStack {
                HStack {
                    ForEach(project.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(geometry.size.width * 0.005) // 0.5vw
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                Text(project.name)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.3) // 40vw, 30vh
    }
}

// Data Model
struct Project: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: String
    let tags: [String]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
