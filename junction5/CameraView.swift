import SwiftUI
import AVFoundation
import PhotosUI
import SceneKit

struct CameraView: View {
    var coordinate: SCNVector3
    @Environment(\.presentationMode) var presentationMode
    @State private var image: UIImage? = nil
    @State private var isShowingCamera = true // Start by showing the camera
    @State private var isUploading = false

    var body: some View {
        ZStack {
            // Background color
            Color.white.edgesIgnoringSafeArea(.all)

            if isUploading {
                // Show loading indicator
                VStack {
                    ProgressView("Uploading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else {
                // Empty view while the camera is being presented
                EmptyView()
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera, onDismiss: {
            if let image = image {
                // Start uploading the image after the camera is dismissed
                uploadImage()
            } else {
                // User canceled the camera; dismiss the view
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
                .edgesIgnoringSafeArea(.all)
        }
    }

    func uploadImage() {
        guard let image = image else { return }

        isUploading = true

        APIService.shared.uploadInventoryItem(image: image, x: coordinate.x, y: coordinate.y, z: coordinate.z) { success in
            DispatchQueue.main.async {
                self.isUploading = false
                if success {
                    print("API call successful.")
                } else {
                    print("API call failed.")
                }
                // Dismiss the view and return to the 3D model
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

}
