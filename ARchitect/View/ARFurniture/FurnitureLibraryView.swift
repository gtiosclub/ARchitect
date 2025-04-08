import SwiftUI

struct FurnitureLibraryView: View {
    @State private var selectedCategory = "Furniture"
    @State private var selectedFilter = "Chairs"
    
    let categories = ["Projects", "Furniture"]
    let filters = [
        ("Chairs", "chair.fill"),
        ("Drawers", "archivebox.fill"),
        ("Lights", "lamp.floor.fill"),
        ("Beds", "bed.double.fill"),
        ("Sofas", "sofa.fill"),
        ("Desks", "table.furniture.fill"),
        ("Shelves", "cabinet.fill")
    ]
    
    let recentItems: [FurnitureItem] = [
        FurnitureItem(name: "Grey Couch", tags: ["Modern", "Grey"], imageName: "GreyCouch2D"),
        FurnitureItem(name: "Green Sofa", tags: ["Contemporary", "Green"], imageName: "greenSofa"),
        FurnitureItem(name: "Orange Couch", tags: ["L-Shaped", "Orange"], imageName: "OrangeCouch"),
        FurnitureItem(name: "L-Shaped Grey Couch", tags: ["L-Shaped", "Grey"], imageName: "longGreyCouch"),
        
        
    ]
    
    var body: some View {
        NavigationView {
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
