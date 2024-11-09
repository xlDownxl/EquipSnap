import SwiftUI
import SceneKit

struct ModelViewWrapper: View {
    @EnvironmentObject var inventoryItemsModel: InventoryItemsModel
    @State private var showPopup = false
    @State private var tappedItem: InventoryItem?

    
    var body: some View {
        
            ZStack {
                ModelSceneView(
                    inventoryItemsModel: inventoryItemsModel,
                    showPopup: $showPopup,
                    tappedItem: $tappedItem
                )
                .edgesIgnoringSafeArea(.all)
                if showPopup, let tappedItem = tappedItem {
                    
                    Color.black.opacity(0.5)
                         .edgesIgnoringSafeArea(.all)
                         .onTapGesture {
                             // Dismiss the popup when the background is tapped
                             showPopup = false
                         }
                    
                    VStack (alignment: .leading) {
                        Button(action: {
                            // Action goes here
                        }) {
                            Text("ADDED")
                                .foregroundColor(.white) // White text color
                                .padding(.horizontal,14)
                                .padding(.vertical,6)
                                .font(.system(size: 12))// Add some padding inside the button
                                .background(Color.green) // Green background color
                                .cornerRadius(15) // Rounded corners
                            
                        }.padding(.bottom,10)
                        
                        
                        Text(tappedItem.equipment_type)
                            .font(.headline)
                        Text(tappedItem.condition).padding(.bottom, 14)
                        
                        Text("Serial Number: "+tappedItem.serial_number)
                            .padding(.bottom, 14)
                        
                        NavigationLink(destination: DetailView(item: tappedItem)) {
                            Text("Check details")
                                .foregroundColor(.blue)
                            
                                .padding(8)// Blue text color
                            //.padding() // Add some padding inside the button
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4) // Slightly rounded corners
                                        .stroke(Color.blue, lineWidth: 2) // Blue outline with a line width of 2
                                )
                        }.navigationTitle("Details")
                        
                    }
                    .frame(width: 230, height: 260)
                    .background(Color.white)
                    //.cornerRadius(10)
                   /* .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )*/
                    .transition(.scale)
                }
                
            }
        }
    
}

#Preview {
    ModelViewWrapper().environmentObject(InventoryItemsModel())
}
