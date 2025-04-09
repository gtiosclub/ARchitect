import SwiftUI

struct ProjectsView: View {
    @Binding var recentMode: RecentMode  // Shared state from GeneralView
    
    @State private var selectedFilter: String = "All Projects"
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""
    @State private var isKeyboardVisible: Bool = false
    
    let projects = [
        Project(name: "Minimalistic", tags: ["Minimalistic"], isLocked: true),
        Project(name: "Bedroom", tags: ["Modern", "Sunlit"], isLocked: false),
        Project(name: "Office", tags: ["Old Gothic", "More"], isLocked: true),
        Project(name: "Living Room", tags: ["Modern", "Sunlit"], isLocked: false),
        Project(name: "Kitchen", tags: ["Modern"], isLocked: false),
        Project(name: "Dining Room", tags: ["Modern"], isLocked: false),
        Project(name: "Sunlit Bedroom", tags: ["Nature", "Cottage core"], isLocked: false),
        Project(name: "Cool Living Room", tags: ["Contemporary", "Colorful"], isLocked: true)
    ]
    
    let projectFilters = ["All Projects", "Favorites", "A-Z", "Private", "Public"]
    let furnitureFilters = ["All Furniture", "Favorites", "A-Z", "Private", "Public"]
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Color(red: 255/255, green: 242/255, blue: 223/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Button(action: {
                                // Profile/user action
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title)
                                    .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                            }
                            Text("Hello, Steven!")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
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
                                .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                        }
                        Button(action: {
                            // Cart action
                        }) {
                            Image(systemName: "cart.fill")
                                .font(.title2)
                                .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                if isSearchActive {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                        TextField("Search projects", text: $searchQuery, onEditingChanged: { isEditing in
                            withAnimation {
                                isKeyboardVisible = isEditing
                            }
                        })
                        .foregroundColor(.primary)
                        .disableAutocorrection(true)
                        Button {
                            withAnimation {
                                searchQuery = ""
                                isSearchActive = false
                                isKeyboardVisible = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 236/255, green: 216/255, blue: 189/255))
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // Big Title
                HStack {
                    Text("Projects")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                        .padding(.horizontal)
                        .padding(.top, 16)
                }
                
                // "Recent" section with navigation buttons
                ScrollView {
                    HStack {
                        Text("Recent")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                        Spacer()
                        HStack {
                            // Box button remains active here
                            Button {
                                recentMode = .box
                            } label: {
                                Image(systemName: "square.split.bottomrightquarter.fill")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                            }
                            // Sofa button switches to furniture
                            Button {
                                recentMode = .sofa
                            } label: {
                                Image(systemName: "sofa")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                            }
                        }
                        .padding(.vertical, 7.5)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(red: 236/255, green: 216/255, blue: 189/255))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Horizontal scroll of sample projects
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
                            ForEach(projectFilters, id: \.self) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                }) {
                                    Text(filter)
                                        .font(.subheadline)
                                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                                        .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 236/255, green: 216/255, blue: 189/255))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: selectedFilter == filter ? 0 : 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 12)
                    
                    // Main grid of projects after applying filters and search query
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredProjects(), id: \.id) { project in
                            ProjectCard(project: project)
                                .frame(width: 173, height: 188)
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 4)
                }
            }
            if !isKeyboardVisible {
                withAnimation {
                    BottomNavigationBar()
                }
            }
        }
    }
    
    // MARK: - Filter Logic
    private func filteredProjects() -> [Project] {
        var result = projects
        if !searchQuery.isEmpty {
            result = result.filter { project in
                project.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        if selectedFilter == "Favorites" {
            result = result.filter { $0.name.contains("Minimalistic") || $0.tags.contains("Minimalistic") }
        } else if selectedFilter == "A-Z" {
            result.sort { $0.name < $1.name }
        } else if selectedFilter == "Private" {
            result = result.filter { $0.isLocked }
        } else if selectedFilter == "Public" {
            result = result.filter { !$0.isLocked }
        }
        return result
    }
}

// MARK: - Model and Card for Projects
struct Project: Identifiable {
    let id = UUID()
    var name: String
    var tags: [String]
    var isLocked: Bool = false
}

struct ProjectCard: View {
    var project: Project
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .clipped()
            
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
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ForEach(project.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 8))
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(red: 206/255, green: 135/255, blue: 35/255))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
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

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
