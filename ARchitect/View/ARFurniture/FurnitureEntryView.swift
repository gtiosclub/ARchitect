//
//  FurnitureEntryView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct FurnitureEntryView: View {
    var body: some View {
        NavigationStack {
            Text("FurnitureEntryView Placeholder")
                .toolbar {
                    NavigationLink {
                        ARSessionView()
                    } label: {
                        Text("Start AR")
                    }

                }
        }
        
    }
}

#Preview {
    FurnitureEntryView()
}
