//
//  ProjectsView.swift
//  ARchitect
//
//  Created by You on 2/13/25.
//

import SwiftUI

enum RecentMode {
    case box
    case sofa
}

struct ProjectsView: View {
    // MARK: - State
    @State private var selectedFilter: String = "All Projects"
    @State private var selectedBottomTab: Int = 0
    @State private var recentMode: RecentMode = .box
    
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""
        
    // Approximate "brownish" color for the bar background
    private let barColor = Color(red: 127/255, green: 109/255, blue: 95/255)
    // Approximate "beige" color for the icons
    private let iconColor = Color(red: 222/255, green: 204/255, blue: 177/255)
    
    // Sample project data
    let projects = [
        Project(name: "Minimalistic", tags: ["Minimalistic"], description: "Short description", isLocked: true),
        Project(name: "Bedroom", tags: ["Modern", "Sunlit"], description: "Short description", isLocked: false),
        Project(name: "Office", tags: ["Old Gothic", "More"], description: "Short description", isLocked: true),
        Project(name: "Living Room", tags: ["Modern", "Sunlit"], description: "Short description", isLocked: false),
        Project(name: "Kitchen", tags: ["Modern"], description: "Short description", isLocked: false),
        Project(name: "Dining Room", tags: ["Modern"], description: "Short description", isLocked: false),
        Project(name: "Sunlit Bedroom", tags: ["Nature", "Cottage core"], description: "Short description", isLocked: false),
        Project(name: "Cool Living Room", tags: ["Contemporary", "Colorful"], description: "Short description", isLocked: true)
    ]
    
    let projectFilters = ["All Projects", "Favorites", "A-Z", "Private", "Public"]
    let furnitureFilters = ["All Furniture", "Favorites", "A-Z", "Private", "Public"]
    
    var body: some View {
        ZStack {
            // Background color matching the mockup’s beige tone
            Color(red: 255/255, green: 242/255, blue: 223/255, opacity: 1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: Top Bar
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Button(action: {
                                // Profile or user action
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                            Text("Hello, Steven!")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    // Right icons
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation {
                                isSearchActive.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        Button(action: {
                            // Cart or bag action
                        }) {
                            Image(systemName: "cart.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                if isSearchActive {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                        TextField("Search projects", text: $searchQuery)
                            .foregroundColor(.primary)
                            .disableAutocorrection(true)
                        Button {
                            // Clear the search and dismiss the bar
                            withAnimation {
                                searchQuery = ""
                                isSearchActive = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(10)
                    .background(
                        // Using a custom theme color that blends with your design
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0))
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // Big Title
                HStack {
                    Text(recentMode == .box ? "Projects" : "Furniture")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.top, 16)
                }
                
                // "Recent" section
                ScrollView {
                    HStack {
                        Text("Recent")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                        HStack {
                            Button {
                                recentMode = .box

                            } label: {
                                Image(systemName: recentMode == .box ? "square.split.bottomrightquarter.fill" : "square.split.bottomrightquarter")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            Button {
                                recentMode = .sofa
                            } label: {
                                Image(systemName: recentMode == .sofa ? "sofa.fill" : "sofa")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 7.5)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        
                    }
                    .padding(.horizontal)
                
                // Horizontal scroll of "Recent" (first 3 for the example)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(projects.prefix(3), id: \.id) { project in
                            ProjectCard(project: project)
                                .frame(width: 123, height: 212)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Filters row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if recentMode == .box {
                            ForEach(projectFilters, id: \.self) { filter in
                                Button(action: {
                                    // Switch filter
                                    selectedFilter = filter
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                                        .foregroundColor(selectedFilter == filter ? Color(red: 99/255, green: 83/255, blue: 70/255, opacity: 1.0) : Color(red: 99/255, green: 83/255, blue: 70/255, opacity: 1.0))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedFilter == filter
                                                      ? Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0)
                                                      : Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: selectedFilter == filter ? 0 : 1)
                                        )
                                }
                            }
                        } else {
                            ForEach(furnitureFilters, id: \.self) { filter in
                                Button(action: {
                                    // Switch filter
                                    selectedFilter = filter
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                                        .foregroundColor(selectedFilter == filter ? Color(red: 99/255, green: 83/255, blue: 70/255, opacity: 1.0) : Color(red: 99/255, green: 83/255, blue: 70/255, opacity: 1.0))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedFilter == filter
                                                      ? Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0)
                                                      : Color(red: 236/255, green: 216/255, blue: 189/255, opacity: 1.0))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: selectedFilter == filter ? 0 : 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 12)
                
                // Main grid of projects
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredProjects(), id: \.id) { project in
                        ProjectCard(project: project)
                            .frame(width: 173, height: 188)
                    }
                }
                .padding([.horizontal, .bottom])
                .padding(.top, 4)
                    
            }
            Spacer()
                HStack {
                    Spacer()
                    
                    // Home button
                    Button(action: {
                        
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title)           // Adjust icon size
                            .foregroundColor(iconColor)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

                    
                    // Plus button
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus.app.fill")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(iconColor)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

                    
                    // Third button (replace "bag.fill" with your desired SF Symbol)
                    Button(action: {
                        
                    }) {
                        Image(systemName: "newspaper.fill")
                            .font(.title)
                            .foregroundColor(iconColor)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    // Rounded rectangle to match the screenshot
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(barColor)
                )
                .padding(.horizontal, 40)   // Moves the bar inward from the screen edges
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2) // Optional shadow
                .ignoresSafeArea()
        }
    }
}
    
    // MARK: - Filter Logic
    private func filteredProjects() -> [Project] {
        // Start with all
        var result = projects
        
        if !searchQuery.isEmpty {
            result = result.filter { project in
                project.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        // Example filter handling
        if selectedFilter == "Favorites" {
            // Suppose "favorites" are those with "Minimalistic" in the name or tags
            result = result.filter { $0.name.contains("Minimalistic") || $0.tags.contains("Minimalistic") }
        } else if selectedFilter == "A-Z" {
            result.sort { $0.name < $1.name }
        } else if selectedFilter == "Private" {
            // Suppose "private" means locked
            result = result.filter { $0.isLocked }
        } else if selectedFilter == "Public" {
            // "public" means not locked
            result = result.filter { !$0.isLocked }
        }
        
        return result
    }
}

// MARK: - Model
struct Project: Identifiable {
    let id = UUID()
    var name: String
    var tags: [String]
    var description: String
    var isLocked: Bool = false
}

// MARK: - Project Card
struct ProjectCard: View {
    var project: Project
    
    var body: some View {
        ZStack {
            // MARK: Background Image
            // Replace the Rectangle placeholder with Image("yourImageName") if you have one.
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .clipped()
            
            // Optional: A gradient overlay to improve text readability.
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                           startPoint: .bottom,
                           endPoint: .center)
            .cornerRadius(12)
            
            if project.isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding([.top, .trailing], 4)
            } else {
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding([.top, .trailing], 4)
            }
            
            // MARK: Overlay Text and Tags
            VStack(alignment: .leading, spacing: 4) {
                
                // Tag row
                HStack {
                    ForEach(project.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 8))
                            .fontWeight(.bold)
                            .frame(height: 9)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(red: 206/255, green: 135/255, blue: 35/255, opacity: 1.0))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Name
                Text(project.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .cornerRadius(12)
    }
}
    
    // MARK: - Preview
    #Preview {
        ProjectsView()
    }
