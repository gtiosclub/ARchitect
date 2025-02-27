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
    var body: some View {
		VStack(alignment: .leading) {
			Spacer()
			HStack {
				Text("Login").font(.system(size:40, weight: .bold, design: .rounded))
					.padding(.leading)
				Spacer().frame(width: 200)
			}
			Spacer().frame(height: 150)
			VStack(alignment: .leading) {
				Text("Username")
					.font(.body)
					.foregroundColor(.black)
				
				TextField("", text: $username)
					.textFieldStyle(.plain)
					.padding(.vertical, 2)
					.overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
			}
			.padding()
			VStack(alignment: .leading) {
				Text("Password")
					.font(.body)
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
				}
			}
			.padding(.vertical)
			HStack {
				Spacer()
				Button(action: {
					print("Welcome \(username), your password is \(password)")
				}) {
					Text("Login")
						.font(.system(size: 20, design: .monospaced))
						.foregroundColor(.white)
						.padding()
						.frame(width: 350, height: 50) // Adjust size to create an oval shape
						.background(Color.black) // Button background color
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
    LoginView()
}
