//
//  NavigationBarView.swift
//  ARchitect
//
//  Created by Ronit Jain on 4/9/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    private let barColor = Color(red: 99/255, green: 83/255, blue: 70/255)
    private let iconColor = Color(red: 222/255, green: 204/255, blue: 177/255)

    // You can add closure parameters for each button if needed.
    var body: some View {
        HStack {
            Spacer()
            
            // Home Button
            NavigationLink(destination: GeneralView().navigationBarBackButtonHidden(true)) {
                Image(systemName: "house.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(iconColor)
            }
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            // Plus Button opens the AR session view (using NavigationLink)
            NavigationLink(destination: ARSessionView()) {
                Image(systemName: "plus.app.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(iconColor)
            }
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            // Third Button (example: News)
            Button(action: {
                // Third button action implementation
            }) {
                Image(systemName: "newspaper.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(iconColor)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(barColor.opacity(0.90))
                .blur(radius: 1)
        )
        .padding(.horizontal, 40)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        .ignoresSafeArea()
    }
}

struct BottomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationBar()
    }
}
