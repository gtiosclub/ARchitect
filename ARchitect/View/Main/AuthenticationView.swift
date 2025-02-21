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
            Text("AR").font(.largeTitle).fontWeight(.bold)
            + Text("chitect").font(.largeTitle).fontWeight(.thin)
            
            TextField("Username/Email", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
            
            SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
            
            Button(action: {
                isAuthenticated = true
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200, height: 50) // Adjust size to create an oval shape
                    .background(Color.white) // Button background color
                    .clipShape(Capsule()) // Makes it an oval
                    .overlay(
                        Capsule().stroke(Color.black, lineWidth: 2) // Black outline
                    )
            }
        }
        
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
}
