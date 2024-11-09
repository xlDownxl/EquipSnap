import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView to enable navigation
            VStack {
                Spacer()
                
                Image("Frame_119") // Replace "Frame_119" with the name of your image in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust to a smaller width and height
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                
                Spacer()
                
                // Welcome Text
                VStack(alignment: .leading, spacing: 0) { // Set alignment to .leading for left alignment
                    Text("Hi Heikki,")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("welcome back to EquipSnap!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading) // Make the VStack take the full width and align to the left
                
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
