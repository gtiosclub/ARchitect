import SwiftUI

struct AuthenticationView: View {
	@Binding var isAuthenticated: Bool
	@State private var isHighlighted = false
	@State private var rectangleColor: Color = .white
	@State private var textColor: Color = .black

	var body: some View {
		NavigationStack {
			VStack {
				Spacer().frame(height: 40)
				HStack {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.fill(rectangleColor)
							.frame(width: 100, height: 100)
							.animation(.easeInOut(duration: 2), value: rectangleColor)
						Text("AR")
							.font(.system(size: 75, design: .rounded))
							.foregroundColor(textColor)
							.animation(.easeInOut(duration: 2), value: textColor)
					}
					Text("chitect")
						.font(.system(size: 75, weight: .ultraLight, design: .rounded))
						.foregroundColor(.black)
				}
				.frame(maxHeight: .infinity, alignment: .top)
				.padding()
				VStack(spacing: 12) {
					NavigationLink(destination: LoginView()) {
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

					NavigationLink(destination: SignUpView()) {
						Text("Sign Up")
							.font(.headline)
							.foregroundColor(.white)
							.padding()
							.frame(width: 350, height: 50) // Adjust size to create an oval shape
							.background(Color.black) // Button background color
							.cornerRadius(15)
					}
				}
				Spacer().frame(height: 150)
			}
		}
		.onAppear {
			startColorChangeTimer()
		}
	}

	func startColorChangeTimer() {
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
			isHighlighted.toggle()
			rectangleColor = isHighlighted ? .black : .white
			textColor = isHighlighted ? .white : .black
		}
	}
}

#Preview {
	AuthenticationView(isAuthenticated: .constant(false))
}
