import SwiftUI

struct FurnitureLibraryView: View {
    @Binding var recentMode: RecentMode  // Shared state from GeneralView
    @State private var selectedFilter = "Sofas"  // Default filter matching sample items
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""
    
    private let barColor = Color(red: 127/255, green: 109/255, blue: 95/255)
    private let iconColor = Color(red: 222/255, green: 204/255, blue: 177/255)
    
    let filters = [
        ("Chairs", "chair.fill"),
        ("Drawers", "archivebox.fill"),
        ("Lights", "lamp.floor.fill"),
        ("Beds", "bed.double.fill"),
        ("Sofas", "sofa.fill"),
        ("Desks", "table.furniture.fill"),
        ("Shelves", "cabinet.fill")
    ]
    
    let recentItems: [Furniture] = [
        Furniture(name: "Grey Couch", tags: ["Modern", "Grey"], imageName: "GreyCouch2D", type: "sofa"),
        Furniture(name: "Green Sofa", tags: ["Contemporary", "Green"], imageName: "greenSofa", type: "sofa"),
        Furniture(name: "Orange Couch", tags: ["L-Shaped", "Orange"], imageName: "OrangeCouch", type: "sofa"),
        Furniture(name: "L-Shaped Grey Couch", tags: ["L-Shaped", "Grey"], imageName: "longGreyCouch", type: "sofa")
    ]
    
    // Mapping from filter title to furniture type used for filtering.
    private var filterMapping: [String: String] {
        return [
            "Chairs": "chair",
            "Drawers": "drawer",
            "Lights": "light",
            "Beds": "bed",
            "Sofas": "sofa",
            "Desks": "desk",
            "Shelves": "shelf"
        ]
    }
    
    var body: some View {
        ZStack {
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
                        TextField("Search projects", text: $searchQuery)
                            .foregroundColor(.primary)
                            .disableAutocorrection(true)
                        Button {
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
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 236/255, green: 216/255, blue: 189/255))
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                // Big Title
                HStack {
                    Text("Furniture")
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
                            // Box button switches to ProjectsView
                            Button {
                                recentMode = .box
                            } label: {
                                Image(systemName: "square.split.bottomrightquarter")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                            }
                            // Sofa button remains active in Furniture view
                            Button {
                                recentMode = .sofa
                            } label: {
                                Image(systemName: "sofa.fill")
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
                    
                    // Horizontal scroll of sample furniture items
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recentItems.prefix(3), id: \.id) { furniture in
                                FurnitureCard(furniture: furniture)
                                    .frame(width: 123, height: 212)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Filters row with both icon and text
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {  // Adjust spacing as needed
                            ForEach(filters, id: \.0) { filter in
                                Button(action: {
                                    selectedFilter = filter.0
                                }) {
                                    VStack(spacing: 6) { // Vertical spacing between icon and text
                                        // Circular background
                                        Circle()
                                            .fill(
                                                selectedFilter == filter.0
                                                ? Color(red: 99/255, green: 83/255, blue: 70/255)  // Darker for selected
                                                : Color(red: 236/255, green: 216/255, blue: 189/255) // Lighter for unselected
                                            )
                                            .frame(width: 56, height: 56)  // Adjust circle size
                                            .overlay(
                                                Image(systemName: filter.1)
                                                    .font(.title2)
                                                    .foregroundColor(
                                                        selectedFilter == filter.0
                                                        ? Color(red: 236/255, green: 216/255, blue: 189/255)
                                                        : Color(red: 99/255, green: 83/255, blue: 70/255)
                                                    )
                                            )
                                        
                                        // Label beneath the circle
                                        Text(filter.0)
                                            .font(.subheadline)
                                            .fontWeight(selectedFilter == filter.0 ? .bold : .regular)
                                            .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 12)
                    
                    // Main grid of furniture items after applying filters and search query
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredFurniture(), id: \.id) { furniture in
                            FurnitureCard(furniture: furniture)
                                .frame(width: 173, height: 188)
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 4)
                }
                
                Spacer()
                // Bottom Navigation Bar
                HStack {
                    Spacer()
                    Button(action: {
                        // Home action
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title)
                            .foregroundColor(iconColor)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    NavigationLink(destination: ARSessionView()) {
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
                    Button(action: {
                        // Third button action
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
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(barColor)
                )
                .padding(.horizontal, 40)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .ignoresSafeArea()
            }
        }
    }
    
    // MARK: - Filter Logic
    private func filteredFurniture() -> [Furniture] {
        var result = recentItems
        if !searchQuery.isEmpty {
            result = result.filter { furniture in
                furniture.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        if let filterType = filterMapping[selectedFilter] {
            result = result.filter { $0.type.lowercased() == filterType }
        }
        return result
    }
}

// MARK: - Model and Card for Furniture
struct Furniture: Identifiable {
    let id = UUID()
    let name: String
    let tags: [String]
    let imageName: String
    let type: String
}

struct FurnitureCard: View {
    var furniture: Furniture
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .clipped()
            
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                           startPoint: .bottom,
                           endPoint: .center)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ForEach(furniture.tags, id: \.self) { tag in
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
                Text(furniture.name)
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

struct FurnitureLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
