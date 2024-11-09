import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView to enable navigation
            VStack {
                Spacer()
                
                // Placeholder Image (Center)
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.blue.opacity(0.5))
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                
                Spacer()
                
                // Welcome Text
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hi Heikki,")
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
            .background(Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    WelcomeView()
}
