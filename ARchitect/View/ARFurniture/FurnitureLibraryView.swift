import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let red = CGFloat((int >> 16) & 0xFF) / 255.0
        let green = CGFloat((int >> 8) & 0xFF) / 255.0
        let blue = CGFloat(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct FurnitureLibraryView: View {
    @Binding var searchText: String //search string
    
    @State private var selectedCategory = "Furniture"
    @State private var selectedFilter = "Chairs"
    
    @State private var selectedItem: FurnitureItem?
    @State private var isDetailedView = false;
    
    let categories = ["Projects", "Furniture"]
    let filters = [
        ("Sofas", "sofa.fill"),
        ("Lights", "lamp.floor.fill"),
        ("Desks", "table.furniture.fill"),
        ("Chairs", "chair.fill"),
        ("Drawers", "archivebox.fill"),
    ]
    
    let recentItems: [FurnitureItem] = [
        //Couches
        FurnitureItem(name: "Grey Couch", tags: ["Modern", "Grey"], imageName: "GreyCouch", category: "Sofas"),
        FurnitureItem(name: "Chelsey Sofa", tags: ["Grey"], imageName: "ChelseyCouch", category: "Sofas"),
        FurnitureItem(name: "Blue Couch", tags: ["Modern", "Blue"], imageName: "BlueCouch", category: "Sofas"),
        FurnitureItem(name: "Dahlia Couch", tags: ["traditional", "small"], imageName: "DahliaCouch", category: "Sofas"),
        FurnitureItem(name: "Leather Couch", tags: ["Leather", "brown"], imageName: "LeatherCouch", category: "Sofas"),
        FurnitureItem(name: "Folding Couch", tags: ["Folding", "Green"], imageName: "FoldingCouch", category: "Sofas"),
        
        //Lamps
        FurnitureItem(name: "Orange Lamp", tags: ["Orange"], imageName: "Orange Lamp", category: "Lights"),
        FurnitureItem(name: "Office Lamp", tags: ["Office", "Black"], imageName: "Office Lamp", category: "Lights"),
        
        //Tables
        FurnitureItem(name: "Dining Table", tags: ["Dining", "wood"], imageName: "DiningTableWood", category: "Desks"),
        FurnitureItem(name: "Dining Table Glass", tags: ["Dining", "glass"], imageName: "DiningTableGlass", category: "Desks"),
        FurnitureItem(name: "Sci Fi Table", tags: ["Science", "steel"], imageName: "SciFiTable", category: "Desks"),
        FurnitureItem(name: "Simple Dining Table", tags: ["Simple", "White"], imageName: "SimpleDiningTable", category: "Desks"),
        FurnitureItem(name: "Office Table", tags: ["Office", "Wood"], imageName: "OfficeTable", category: "Desks"),
        
        //Chairs
        FurnitureItem(name: "Living Room Chair", tags: ["Wooden", "Warm"], imageName: "Living Room Chair", category: "Chairs"),
        FurnitureItem(name: "European Chair", tags: ["European", "Cream"], imageName: "European Chair", category: "Chairs"),
        FurnitureItem(name: "Dublin Chair", tags: ["Leather", "Black"], imageName: "DublinChair", category: "Chairs"),
        FurnitureItem(name: "Arm Chair", tags: ["Linen", "Grey"], imageName: "armChair", category: "Chairs"),
        FurnitureItem(name: "Blue Chair", tags: ["Office", "Blue"], imageName: "blueChair", category: "Chairs"),
        
        //Drawers
        FurnitureItem(name: "Wooden Drawer", tags: ["Nighstand", "Wooden"], imageName: "Wooden Drawer", category: "Drawers"),
       
        
       
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
            VStack {
                // Recent Items
                Text("Recent")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(recentItems.prefix(3)) { item in
                            NavigationLink(destination: FurnitureDetailView(item: item)) {
                                FurnitureCard(item: item)
                                    .frame(width:150, height:200)
                                    .foregroundColor(.black)

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
                        ForEach(filters, id: \.0) { filter in
                            Button(action: { selectedFilter = filter.0 }) {
                                VStack {
                                    Image(systemName: filter.1)
                                        .font(.title2)
                                        .foregroundColor(selectedFilter == filter.0 ? .white : Color(hex: "#3E2A47") //dark brown for filter icon
)
                                        .padding()
                                        .background(selectedFilter == filter.0 ? Color.brown : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    Text(filter.0)
                                        .font(.caption)
                                        .foregroundColor(selectedFilter == filter.0 ? .black : .gray)
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
                .padding()
                
                // Grid of Items
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(recentItems.filter { $0.category == selectedFilter }) { item in
                            NavigationLink(destination: FurnitureDetailView(item: item)) {
                                FurnitureCard(item: item)
                                    .foregroundColor(.black)
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
                        Button {
                            isPresentingAR = true
                            print(selectedFurniture)
                        } label: {
                            Text("View in AR")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 99/255, green: 83/255, blue: 70/255))
                                .cornerRadius(12)
                        }
                        .fullScreenCover(isPresented: $isPresentingAR) {
                            Furniture3DViewWrapper(modelName: selectedFurniture.name)
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
            .background(Color(hex: "#FFF2DF")) //set back ground
        
            
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
    let category: String
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
                        
                        
                            .font(.caption)
                            .padding(4)
                            .foregroundColor(Color(hex: "#FFF2DF"))
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(5)
                    }
                }
                
                Text(item.name)
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(Color(hex: "#635346"))

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(width: 160)
        .background(Color(hex: "#FFF2DF"))
        .shadow(radius: 3)
    }
}
struct Furniture3DViewWrapper: UIViewControllerRepresentable {
    var modelName: String

    func makeUIViewController(context: Context) -> Furniture3DView {
        let vc = Furniture3DView()
        vc.modelName = modelName
        return vc
    }

    func updateUIViewController(_ uiViewController: Furniture3DView, context: Context) {}
}

struct HomeView_Previews: PreviewProvider {
    @State static var placeHolderSearchText = ""

    static var previews: some View {
        FurnitureLibraryView(searchText: $placeHolderSearchText)
    }
}
