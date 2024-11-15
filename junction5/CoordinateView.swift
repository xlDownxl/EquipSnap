import SwiftUI
import SceneKit

struct CoordinateView: View {
    var coordinate: SCNVector3
    //@EnvironmentObject var savedCoordinatesModel: SavedCoordinatesModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Coordinate:")
            Text("x: \(coordinate.x)")
            Text("y: \(coordinate.y)")
            Text("z: \(coordinate.z)")
            Spacer()
            HStack {
                Button("Save") {
                    //savedCoordinatesModel.coordinates.append(coordinate)
                    // Post notification when coordinate is saved
                    NotificationCenter.default.post(name: NSNotification.Name("CoordinateSaved"), object: nil)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
        }
    }
}

#Preview {
    CoordinateView(coordinate: SCNVector3(0, 0, 0))//.environmentObject(SavedCoordinatesModel())
}
