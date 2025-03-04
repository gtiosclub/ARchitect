//
//  FurnitureLibraryView.swift
//  ARchitect
//
//  Created by Lingchen Xiao on 2/11/25.
//

import SwiftUI
import RealityKit

struct FurnitureLibraryView: View {
    var body: some View {
        VStack {
           Text("Furniture Library")
                .fixedSize()
            //let url = URL(fileURLWithPath: "GreyCouch.usdz")
            //let entity = try? Entity.load(contentsOf: url)
            Image("GreyCouch2D")
                .resizable()
                .scaledToFit()

        }
    }
}

#Preview {
    FurnitureLibraryView()
}
