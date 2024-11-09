import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView to enable navigation
            VStack {
                Spacer()
                
                // Custom Image (Center)
                Image("Frame_122") // Replace "welcomeImage" with the name of your image in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400) // Adjust size as needed
                    .cornerRadius(10)
                    .padding(.bottom, 00)
                
                Spacer()
                
                // Welcome Text
                VStack(alignment: .leading, spacing: 40) {
                    Text("            Hey")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("welcome back to EquipSnap!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                
                // Next Button with Navigation to MainView
                NavigationLink(destination: MainView()) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            //.background(Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
