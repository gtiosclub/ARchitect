//
//  AuthenticationView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool;
    @State private var name: String = "";
    @State private var password: String = "";
    
    var body: some View {
        VStack {
            Text("AR").font(.custom("SF Pro", size: 40))
            + Text("chitect").font(.largeTitle).fontWeight(.ultraLight)
            
//            TextField("Username/Email", text: $name)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//            
//            SecureField("Password", text: $password)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
            
            Button(action: {
                
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 346, height: 46)
                    .background(Color.white) // Button background color
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 2) // Black outline
                    )
            }
            
            Button(action: {
                
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 350, height: 50) // Adjust size to create an oval shape
                    .background(Color.black) // Button background color
                    .cornerRadius(15)
            }
        }
        
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
}
