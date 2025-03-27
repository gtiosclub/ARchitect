//
//  LoginView.swift
//  ARchitect
//
//  Created by Preyas Joshi on 2/20/25.
//

import SwiftUI

struct LoginView: View {
	@State private var username: String = ""
	@State private var password: String = ""
    @Binding var isAuthenticated: Bool
    
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 100)
			HStack {
				Text("Login").font(.system(size:40, weight: .bold, design: .monospaced))
					.padding(.leading)
				Spacer().frame(width: 200)
			}
			Spacer().frame(height: 100)
			VStack(alignment: .leading) {
				Text("Username")
					.font(.system(size:20, design: .monospaced))
					.foregroundColor(.black)
				
				TextField("", text: $username)
					.textFieldStyle(.plain)
					.padding(.vertical, 2)
					.overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
			}
			.padding()
			VStack(alignment: .leading) {
				Text("Password")
					.font(.system(size:20, design: .monospaced))
					.foregroundColor(.black)
				
				TextField("", text: $password)
					.textFieldStyle(.plain)
					.padding(.vertical, 2)
					.overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
			}
			.padding(.horizontal)
			HStack {
				Spacer().frame(width: 230)
				Button(action: {
					
				}) {
					Text("Forgot Password?").font(.system(size:20, weight: .light))
						.foregroundColor(.gray)
				}
			}
			.padding(.vertical)
			Spacer().frame(height: 70)
			HStack {
				Spacer()
				Button(action: {
                    isAuthenticated = true
					print("Welcome \(username), your password is \(password)")
				}) {
					Text("Login")
						.font(.system(size: 20, design: .monospaced))
						.foregroundColor(.white)
						.padding()
						.frame(width: 350, height: 50)
						.background(Color.black)
						.cornerRadius(15)
				}
				Spacer()
			}
			Spacer().frame(height: 250)
		}
		.frame(maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}
