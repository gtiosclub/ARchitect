//
//  FurnitureItem.swift
//  ARchitect
//
//  Created by lucasmikan on 3/3/25.
//
// Models/FurnitureItem.swift
import SwiftUI

struct FurnitureItem: Identifiable {
    let id = UUID()
    
    let name: String
    //let styleTags: [String]
    let imageName: String
    let isLocked: Bool
}

