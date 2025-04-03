//
//  ProjectView.swift
//  ARchitect
//
//  Created by Aryan Chokshi on 2/13/25.
//

import SwiftUI

struct ProjectsView: View {
    @State private var selectedTab: String = "Projects"
    @State private var searchText: String = ""
    @State private var selectedFilter: String = "All Projects"
    
    let tabs = ["Projects", "Furniture"]
    let filters = ["All Projects", "Favorites", "A-Z", "Private", "Public"]
    
    // Sample project data
    @Binding var projects: [Project]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Recent section
                            Text("Recent")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // Display first two projects in horizontal scroll
                                    ForEach(projects.prefix(2), id: \.name) { project in
                                        ProjectCard(project: project, isLocked: false)
                                            .frame(width: 170, height: 220)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Filters
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(filters, id: \.self) { filter in
                                        Button(action: {
                                            selectedFilter = filter
                                        }) {
                                            Text(filter)
                                                .fontWeight(selectedFilter == filter ? .bold : .regular)
                                                .foregroundColor(.black)
                                                .padding(.bottom, 5)
                                                .overlay(
                                                    Rectangle()
                                                        .frame(height: 2)
                                                        .foregroundColor(selectedFilter == filter ? .black : .clear)
                                                        .offset(y: 4),
                                                    alignment: .bottom
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Grid of projects
                            //                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            //                            ForEach(projects, id: \.name) { project in
                            //                                ProjectCard(project: project, isLocked: Bool.random())
                            //                                    .frame(height: 220)
                            //                            }
                            //                        }
                            //                        .padding(.horizontal)
                        }
                    }
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach($projects) { $project in
                                NavigationLink(destination: ProjectDetailView(project: .constant(project))) {
                                    ProjectCard(project: project, isLocked: false)
                                        .frame(height: 220)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

// Model for project data
struct Project: Identifiable {
    var id = UUID()
    var name: String
    var tags: [String]
    var description: String
    var screenshot: UIImage? = nil
}

// Project card component
struct ProjectCard: View {
    var project: Project
    var isLocked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                if let screenshot = project.screenshot {
                    Image(uiImage: screenshot)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(10)
                }
                
                // Lock icon
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            
            // Tags
            HStack {
                ForEach(project.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(getTagColor(tag))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            Text(project.name)
                .font(.headline)
            
            if !project.description.isEmpty {
                Text(project.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    // Function to get color based on tag name
    func getTagColor(_ tag: String) -> Color {
        switch tag {
        case "Modern":
            return Color.orange
        case "Sunlit":
            return Color.orange.opacity(0.8)
        case "Minimalistic":
            return Color.orange
        case "90s":
            return Color.orange
        case "Nature":
            return Color.orange
        case "Cottage core":
            return Color(red: 0.9, green: 0.6, blue: 0.3)
        case "Contemporary":
            return Color.orange
        case "Colorful":
            return Color(red: 0.9, green: 0.5, blue: 0.3)
        default:
            return Color.gray
        }
    }
}

struct ProjectDetailView: View {
    @Binding var project: Project

    var body: some View {
        Form {
            Section(header: Text("Preview")) {
                if let screenshot = project.screenshot {
                    Image(uiImage: screenshot)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
            }
            Section(header: Text("Project Name")) {
                TextField("Name", text: $project.name)
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $project.description)
            }
        }
        .navigationTitle("Edit Project")
    }
}

#Preview {
    ProjectsView(projects: .constant([
           Project(name: "Living Room", tags: ["Modern"], description: "A modern living room design."),
           Project(name: "Office Space", tags: ["Minimalistic"], description: "A clean and minimalistic office setup.")
       ]))
}
