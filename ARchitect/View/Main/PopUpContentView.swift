//
//  ARPopupView.swift
//  ARchitect
//
//  Created by Ivan Li on 3/31/25.
//

import SwiftUI
struct PopUpContentView: View {
	let categories = [
		"Chairs", "Lights", "Tables", "Sofas"
	]
	let icons = [
		"chair", "cabinet", "lamp.desk", "bed.double",
	]
	let items: [FurnitureItem] = [
		FurnitureItem(name: "Dining Chair", type: "Chairs", tags: ["Modern"], imageName: "chair1"),
		FurnitureItem(name: "Parson Dining Chair", type: "Chairs", tags: ["Vintage"], imageName: "chair2"),
		FurnitureItem(name: "Bloss Dining Chair", type: "Chairs", tags: ["Minimalistic"], imageName: "chair3"),
		FurnitureItem(name: "Tufted Dining Chair", type: "Chairs", tags: ["Vintage", "Blue"], imageName: "chair4"),
		FurnitureItem(name: "Mooshie Table Lamp", type: "Lights", tags: ["Modern"], imageName: "lamp1"),
		FurnitureItem(name: "Marble Table Lamp", type: "Lights", tags: ["Contemporary"], imageName: "lamp2"),
		FurnitureItem(name: "Oslo Table Lamp", type: "Lights", tags: ["Minimalistic"], imageName: "lamp3"),
		FurnitureItem(name: "Sanna Floor Lamp", type: "Lights", tags: ["Vintage"], imageName: "lamp4"),
	]
	@State private var selectedCategory = "Chairs"
	var body: some View {
		VStack {
			// Navigation Bar
			Spacer()
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(categories, id: \.self) { category in
						Button(action: {
							selectedCategory = category
						}) {
							VStack {
								Image(selectedCategory == category ?  category+"_active" : category+"_inactive")
								Text(category)
									.font(.caption)
									.foregroundColor(.black)
							}
						}
						.padding(.horizontal, 5)
					}
				}
				.padding()
			}
			
			// Grid of Furniture Items
			ScrollView {
				LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
					ForEach(items.filter { $0.type == selectedCategory}) { item in
						FurnitureItemView(item: item)
					}
				}
				.padding(.horizontal)
			}
		}
	}
}

struct FurnitureItemView: View {
	let item: FurnitureItem
	
	var body: some View {
		VStack(alignment: .leading) {
			Image(item.imageName)
				.resizable()
				.scaledToFit()
				.cornerRadius(30)
			
			HStack {
				ForEach(item.tags, id: \.self) { tag in
					Text(tag)
						.font(.caption)
						.padding(5)
						.background(Color.orange.opacity(0.8))
						.foregroundColor(.white)
						.cornerRadius(5)
				}
			}
			
			Text(item.name)
				.font(.headline)
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(10)
	}
}


struct PopUpContent_Previews: PreviewProvider {
	static var previews: some View {
		PopUpContentView()
	}
}
