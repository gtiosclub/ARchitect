import SwiftUI

struct FurnitureLibraryView: View {
    @Binding var recentMode: RecentMode
    @State private var selectedFilter = "Sofas"
    
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""
    @State private var isKeyboardVisible: Bool = false
    @State private var selectedFurniture: Furniture? = nil

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
    
    let sampleRelatedItems: [(String, String)] = [
        ("Rond table", "rondTableImage"), // <– Replace with real asset name
        ("Chaich", "chaichImage"),
        ("Parson Chair", "parsonChairImage")
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
        ZStack(alignment: .bottom) {
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
                                withAnimation {
                                    recentMode = .box
                                }
                            } label: {
                                Image(systemName: "square.split.bottomrightquarter")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 99/255, green: 83/255, blue: 70/255))
                            }
                            // Sofa button remains active in Furniture view
                            Button {
                                withAnimation {
                                    recentMode = .sofa
                                }
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
                                    .onTapGesture {
                                        withAnimation {
                                            selectedFurniture = furniture
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Filters row with circular icons and labels
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(filters, id: \.0) { filter in
                                Button(action: {
                                    selectedFilter = filter.0
                                }) {
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(
                                                selectedFilter == filter.0
                                                ? Color(red: 99/255, green: 83/255, blue: 70/255)
                                                : Color(red: 236/255, green: 216/255, blue: 189/255)
                                            )
                                            .frame(width: 56, height: 56)
                                            .overlay(
                                                Image(systemName: filter.1)
                                                    .font(.title2)
                                                    .foregroundColor(
                                                        selectedFilter == filter.0
                                                        ? Color(red: 236/255, green: 216/255, blue: 189/255)
                                                        : Color(red: 99/255, green: 83/255, blue: 70/255)
                                                    )
                                            )
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
                    
                    // Main grid of furniture items after filtering and search query
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredFurniture(), id: \.id) { furniture in
                            FurnitureCard(furniture: furniture)
                                .frame(width: 173, height: 188)
                                .onTapGesture {
                                    withAnimation {
                                        selectedFurniture = furniture
                                    }
                                }
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
            
            // Black popup overlay when a furniture item is selected.
            if let selectedFurniture = selectedFurniture {
                ZStack {
                    // Dark, translucent background behind the card
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // Close popup if user taps outside the card
                            withAnimation {
                                self.selectedFurniture = nil
                            }
                        }
                    
                    // The popup card
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Close button at top-right
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    self.selectedFurniture = nil
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color.gray.opacity(0.6))
                            }
                        }
                        
                        // Main item image
                        // Replace furniture.imageName with your actual asset name if needed.
                        Image(selectedFurniture.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)         // Adjust to your preference
                            .frame(height: 160)          // Example height
                            .cornerRadius(12)
                            .padding(.top, -12)          // Pulls image up a bit if desired
                        
                        // Title and short description
                        Text(selectedFurniture.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text("A modern dining chair with wooden legs and a grey seat. Looks great in any contemporary dining space.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.8))
                            .lineLimit(nil)
                        
                        // “Related Items” header
                        Text("Related Items")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        
                        // Related items row (example placeholders)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Replace with your real “related items” data
                                ForEach(sampleRelatedItems, id: \.0) { relatedItem in
                                    VStack(spacing: 4) {
                                        // Placeholder image or real image
                                        Image(relatedItem.1)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(6)
                                        
                                        Text(relatedItem.0)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        NavigationLink(destination: Furniture3DView(item: selectedFurniture)) {
                            Text("View in AR")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 99/255, green: 83/255, blue: 70/255))
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            // Matches your overall beige scheme:
                            .fill(Color(red: 255/255, green: 242/255, blue: 223/255))
                    )
                    .frame(width: 320) // Adjust card width to suit your design
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)
                }
                .transition(.opacity)  // Fade in/out transition
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

// MARK: - Model and Card
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
                            .lineLimit(1)
                    }
                }
                Text(furniture.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
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
