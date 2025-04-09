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
    @State private var selectedCategory = "Furniture"
    @State private var selectedFilter = "Chairs"
    
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
       
        
        
    ]
    
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
                                        .foregroundColor(selectedFilter == filter.0 ? .white : Color(hex: "#3E2A47") //dark brown for filter icon
)
                                        .padding()
                                        .background(selectedFilter == filter.0 ? Color.brown : Color.gray.opacity(0.2))
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
                        ForEach(recentItems.filter { $0.category == selectedFilter }) { item in
                            NavigationLink(destination: FurnitureDetailView(item: item)) {
                                FurnitureCard(item: item)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    .padding()
                }
                
            }
            .background(Color(hex: "#FFF2DF")) //set back ground
        
            
        }
       
}

struct FurnitureItem: Identifiable {
    let id = UUID()
    let name: String
    let tags: [String]
    let imageName: String
    let category: String
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
        .background(Color(hex: "#FFF2DF"))
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
