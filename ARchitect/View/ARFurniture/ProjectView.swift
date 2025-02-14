//
//  ProjectView.swift
//  ARchitect
//
//  Created by Aryan Chokshi on 2/13/25.
//

import SwiftUI

import SwiftUI

struct ProjectView: View {
    @State private var selectedTab: String = "Projects"
    @State private var searchText: String = ""
    @State private var selectedFilter: String = "All Projects"
    
    let tabs = ["Projects", "Furniture"]
    let filters = ["All Projects", "Favorites", "A-Z", "Private", "Public"]
    
    // Sample project data
    let projects = [
        Project(name: "Living Room", tags: ["Modern", "Sunlit"], description: "Short description"),
        Project(name: "Office", tags: ["Minimalistic"], description: "Short description"),
        Project(name: "Office", tags: ["90s"], description: "Short description"),
        Project(name: "Office", tags: ["Minimalistic"], description: "Short description"),
        Project(name: "Kitchen", tags: ["Modern"], description: "Short description"),
        Project(name: "Living Room", tags: ["Modern", "Sunlit"], description: "Short description"),
        Project(name: "Sunlit Bedroom", tags: ["Nature", "Cottage core"], description: "Short description"),
        Project(name: "Cool Living Room", tags: ["Contemporary", "Colorful"], description: "Short description")
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Header with Home and Search Bar side by side
                HStack(alignment: .center, spacing: 12) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchText)
                        
                        Image(systemName: "mic.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Tab buttons
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                selectedTab = tab
                            }
                        }) {
                            HStack {
                                if tab == "Projects" {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.system(size: 16))
                                } else {
                                    Image(systemName: "chair.fill")
                                        .font(.system(size: 16))
                                }
                                
                                Text(tab)
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selectedTab == tab ? .white : .black)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(selectedTab == tab ?
                                          Color(red: 0.35, green: 0.45, blue: 0.35) :
                                          Color.clear)
                            )
                        }
                    }
                }
                .padding(4)
                .background(Color(.systemGray5))
                .cornerRadius(25)
                .padding(.horizontal)
                
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
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(projects, id: \.name) { project in
                                ProjectCard(project: project, isLocked: Bool.random())
                                    .frame(height: 220)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
    }
}

// Model for project data
struct Project {
    var name: String
    var tags: [String]
    var description: String
}

// Project card component
struct ProjectCard: View {
    var project: Project
    var isLocked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // Placeholder image
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(10)
                
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

#Preview {
    ProjectView()
}
