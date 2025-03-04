//
//  FurnitureCard.swift
//  ARchitect
//
//  Created by lucasmikan on 3/3/25.
//
// Views/FurnitureCard.swift
import SwiftUI

struct FurnitureCard: View {
    let item: FurnitureItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Image + lock icon
            ZStack(alignment: .topTrailing) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 160)
                    .clipped()
                    .cornerRadius(8)
                
                if item.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding([.top, .trailing], 6)
                }
            }
        
            
            // Furniture name
            Text(item.name)
                .font(.footnote)
                .foregroundColor(.primary)
        }
        .frame(width: 140)
    }
}

