import SwiftUI

struct MainView: View {
    var body: some View {
        
            VStack {
                NavigationLink(destination: InventoryView()) { // Navigate to InventoryView
                    Text("Add Inventory")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Main View")
        }
    
}
