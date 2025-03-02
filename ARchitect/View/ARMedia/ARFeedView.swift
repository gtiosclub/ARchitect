//
//  ARFeedView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct ARFeedView: View {
    @StateObject var sheetManager = SheetManager()
    //    @State private var showingAlert = false
    var body: some View {
        ZStack{
            Color
                .white
                .ignoresSafeArea()
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .overlay(
                    Text("Tap here")
                        .foregroundColor(.white)
                        .font(.headline)
                )
                .gesture(
                    TapGesture()
                        .onEnded {
                            withAnimation {
                                sheetManager.present()
                            }
                        }
                )
        }
        .overlay(alignment: .center){
            if sheetManager.isPresented {
                InformationPopUpView{
                    withAnimation{
                        sheetManager.dismiss()
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    ARFeedView()
        .environmentObject(SheetManager())

}
