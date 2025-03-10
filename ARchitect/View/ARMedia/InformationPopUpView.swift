//
//  PopUpView.swift
//  ARchitect
//
//  Created by Meherika Majumdar on 13/2/25.
//

import SwiftUI

struct InformationPopUpView: View {
    @EnvironmentObject var sheetManager: SheetManager
    
    let didClose: () -> Void
    let name: String
    let description: String
    let cost: String
    let stores: String

    var body: some View {
        VStack(spacing: 12) {
            // Title
            Text(name.isEmpty ? "Furniture Name" : name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .foregroundColor(.black)

            // Information Sections
            VStack(alignment: .leading, spacing: 10) {
                labeledText(title: "Description:", content: description.isEmpty ? "No description available." : description)
                labeledText(title: "Cost:", content: cost.isEmpty ? "N/A" : cost)
                labeledText(title: "Stores:", content: stores.isEmpty ? "No store information available." : stores)
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(width: 280, height: 300)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 6))
        .overlay(alignment: .topTrailing) {
            close
        }
        .transition(.opacity)
    }
    
    // Helper function for consistent label formatting
    private func labeledText(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            Text(content)
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
    }
    
    private var close: some View {
        Button {
            sheetManager.dismiss()
            didClose()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white.opacity(0.6))
        }
    }
}

#Preview {
    InformationPopUpView(
        didClose: {},
        name: "Modern Chair",
        description: "A chair with a simple, clean design.",
        cost: "$499.99",
        stores: "Available at your nearest IKEA, Target, and Walmart."
    )
    .environmentObject(SheetManager())
}
