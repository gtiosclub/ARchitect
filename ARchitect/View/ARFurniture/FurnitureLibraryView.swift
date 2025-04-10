import SwiftUI

struct FurnitureLibraryView: View {
    @Binding var recentMode: RecentMode
    @State private var selectedFilter = "Sofas"
    @State private var isPresentingAR = false
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
        Furniture(name: "L-Shaped Grey Couch", tags: ["L-Shaped", "Grey"], imageName: "longGreyCouch", type: "sofa"),
        Furniture(name: "modern chair", tags: ["Grey"], imageName: "longGreyCouch", type: "chair")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Recent Items
                Text("Recent")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recentItems.prefix(3)) { item in
                            NavigationLink(destination: FurnitureDetailView(item: item)) {
                                FurnitureCard(item: item)
                                    .frame(width:150, height:200)
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filters, id: \.0) { filter in
                            Button(action: { selectedFilter = filter.0 }) {
                                VStack {
                                    Image(systemName: filter.1)
                                        .font(.title2)
                                        .foregroundColor(selectedFilter == filter.0 ? .white : .black)
                                        .padding()
                                        .background(selectedFilter == filter.0 ? Color.green : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    Text(filter.0)
                                        .font(.caption)
                                        .foregroundColor(selectedFilter == filter.0 ? .black : .gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                // Grid of Items
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(recentItems) { item in
                            NavigationLink(destination: FurnitureDetailView(item: item)) {
                                    FurnitureCard(item: item)
                                    .foregroundColor(.black)
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
                }
                
            }
        }
            
        }
       
}

struct FurnitureItem: Identifiable {
    let id = UUID()
    let name: String
    let tags: [String]
    let imageName: String
}

struct FurnitureCard: View {
    let item: FurnitureItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                Image(systemName: "lock.fill")
                    .padding(8)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Circle())
                    .padding(8)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                        
                        
                            .font(.caption)
                            .padding(4)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(5)
                    }
                }
                
                Text(item.name)
                    .font(.headline)
                    .bold()
            }
            .padding(.horizontal)
        }
        .frame(width: 160)
        .background(Color.white)
        .cornerRadius(10)
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

struct BottomNavItem: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.title2)
            .foregroundColor(.black)
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        FurnitureLibraryView()
    }
}
