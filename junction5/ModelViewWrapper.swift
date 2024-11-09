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
                        VStack {
                            Text("Equipment Type")
                                .font(.subheadline)
                            Text(tappedItem.equipment_type)
                                .font(.headline)
                            Button("Close") {
                                showPopup = false
                            }
                            .padding()
                        }
                        .frame(width: 170, height: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .transition(.scale)
                    }
                
        }
    }
}

#Preview {
    ModelViewWrapper().environmentObject(InventoryItemsModel())
}
