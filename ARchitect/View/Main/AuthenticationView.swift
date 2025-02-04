//
//  AuthenticationView.swift
//  ARchitect
//
//  Created by Songyuan Liu on 2/4/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
        VStack {
            Text("AuthenticationView Placeholder")
            Button("Press to authenticate") {
                isAuthenticated = true
            }
        }
        
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
}
