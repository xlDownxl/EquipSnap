/*import SwiftUI

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
#Preview {MainView()
}
*/
import SwiftUI
import MapKit

struct MainView: View {
    // State to manage map region and marker location
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1675, longitude: 24.9311), // Centered on Helsinki as an example
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var locationAddress = "Kaapeliaukio 3, 00180 Helsinki" // Example address
    @State private var isLocationConfirmed = false // State to track if location is confirmed

    var body: some View {
        VStack {
            // Navigation bar title
            Text("Current location")
                .font(.headline)
                .padding(.top, 10)

            // Map view with a marker
            Map(coordinateRegion: $region, annotationItems: [MapMarkerLocation(coordinate: region.center)]) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
            .frame(height: 300) // Adjust height as needed
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Location display text field (read-only)
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("Address", text: $locationAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true) // Make the text field read-only
                    .padding(.bottom, 20)
            }
            .padding(.horizontal)

            // Confirm location button
            //Button(action: {
              //  isLocationConfirmed = true
                
            NavigationLink(destination: InventoryView()) { // Navigate to InventoryView
                    Text("Confirm location")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            /*}) {
                Text("Confirm location")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }*/
            .padding(.horizontal)
            .alert(isPresented: $isLocationConfirmed) {
                Alert(title: Text("Location Confirmed"), message: Text("You have confirmed the location."), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(false)
    }
}

// Helper structure for map annotation
struct MapMarkerLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

#Preview {
    MainView()
}
