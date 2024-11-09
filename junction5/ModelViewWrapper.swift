import SwiftUI
import SceneKit

struct ModelViewWrapper: View {
    @EnvironmentObject var inventoryItemsModel: InventoryItemsModel
    
    var body: some View {
        ZStack {
            ModelSceneView(inventoryItemsModel: inventoryItemsModel)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ModelViewWrapper().environmentObject(InventoryItemsModel())
}
