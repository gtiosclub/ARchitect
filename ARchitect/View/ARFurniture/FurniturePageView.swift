import SwiftUI

struct FurniturePageView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: FurnitureCategories? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding()
                
                Spacer()
                Text("Home")
                    .font(.title.bold())
                Spacer()
            }
            .padding(.top, -10) // Lifting the whole page slightly up
            
            Text("Recent")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(SampleFurniture.recent) { furniture in
                    FurnitureCardView(furniture: furniture)
                }
            }
            .padding()
            
            Text("Categories")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                ForEach(FurnitureCategories.allCases, id: \ .self) { category in
                    CategoryButton(category: category, selectedCategory: $selectedCategory)
                }
            }
            .padding()
            
            Spacer()
                .frame(height: 20) // Ensure space for category results
            
            if let selectedCategory = selectedCategory {
                Text("Showing: \(selectedCategory.rawValue)")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(FurnitureItem.items(for: selectedCategory)) { furniture in
                        FurnitureCardView(furniture: furniture)
                    }
                }
                .padding()
            } else {
                Spacer()
                    .frame(height: 150) // Empty space for non-selected state
            }
        }
    }
}

enum FurnitureCategories: String, CaseIterable {
    case table = "Table"
    case wardrobe = "Wardrobe"
    case chair = "Chair"
    case couch = "Couch"
}

extension FurnitureItem {
    static func items(for category: FurnitureCategories) -> [FurnitureItem] {
        switch category {
        case .table:
            return SampleFurniture.table
        case .wardrobe:
            return SampleFurniture.wardobe
        case .chair:
            return SampleFurniture.chair
        case .couch:
            return SampleFurniture.couch
        }
    }
}

struct FurnitureCardView: View {
    let furniture: FurnitureItem
    
    var body: some View {
        VStack {
            Image(furniture.imageName) // Use image name directly
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
            
            HStack {
                Text(furniture.name)
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}




struct CategoryButton: View {
    let category: FurnitureCategories
    @Binding var selectedCategory: FurnitureCategories?
    
    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            VStack {
                Image(systemName: "square.grid.2x2") // Placeholder icon
                Text(category.rawValue)
                    .font(.caption)
            }
            .padding()
            .background(selectedCategory == category ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}
