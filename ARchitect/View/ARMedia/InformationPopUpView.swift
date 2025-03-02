//
//  PopUpView.swift
//  ARchitect
//
//  Created by Meherika Majumdar on 13/2/25.
//

import SwiftUI

struct InformationPopUpView: View {
    @EnvironmentObject var sheetManager: SheetManager
    
    let didClose : () -> Void
    var body: some View {
        VStack(spacing: .zero){
            title
            description
            cost
            stores
        }
        .frame(width: 300)
        .padding(.horizontal,24)
        .padding(.vertical,40)
        .multilineTextAlignment(.center)
        .background(background)
        .overlay(alignment: .topTrailing) {
            close
        }
        .transition(.opacity)
    }
}

private extension InformationPopUpView{
    var close: some View{
        Button {
            sheetManager.dismiss()
            didClose()
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.circle.fill)
                .font(
                    .system(size: 35,weight: .bold)
                )
            .foregroundStyle(.gray.opacity(0.4))
            .padding(8)
        }
    }
    var title: some View{
        Text("Furniture Name")
            .font(
                .system(size: 30,weight: .bold)
            )
            .padding()
    }
    var description: some View{
        VStack(alignment: .leading, spacing: 5){
            Text("Description:")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.black.opacity(0.8))
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .multilineTextAlignment(.leading)
        }
    }
    var cost: some View{
        VStack(alignment: .leading, spacing: 5){
            Text("Cost:")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.black.opacity(0.8))
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .multilineTextAlignment(.leading)
        }
    }
    var stores: some View{
        VStack(alignment: .leading, spacing: 5){
            Text("Stores:")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.black.opacity(0.8))
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .multilineTextAlignment(.leading)
        }
    }

}

private extension InformationPopUpView{
    var background: some View{
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.5), radius: 3)

    }
}

#Preview {
    InformationPopUpView{}
        .environmentObject(SheetManager())
        .padding()
}
