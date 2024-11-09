import SwiftUI
import SceneKit

struct InventoryView: View {
    @State private var selectedView: String = "Map view"
    @StateObject var inventoryItemsModel = InventoryItemsModel()

    var body: some View {
        VStack {
            // Fixed "Add Inventory" button at the top
            NavigationLink(destination: ChatView(position: nil)) {
                Text("Add Inventory")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 16)
            
            // Map view and List view toggle
            Picker("View Selection", selection: $selectedView) {
                Text("Map view").tag("Map view")
                Text("List view").tag("List view")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Conditional content rendering based on selected view
            if selectedView == "List view" {
                if inventoryItemsModel.items.isEmpty {
                    // Display message when there are no inventory items
                    VStack {
                        Spacer()
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.blue.opacity(0.5))
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        
                        Text("No inventory in this building")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("You can create inventory by clicking the button above, or adding from map view to load location data.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                } else {
                    // Display the list of inventory items if they exist
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(inventoryItemsModel.items) { item in
                                // Wrap InventoryRow in NavigationLink
                                NavigationLink(destination: DetailView(item: item)) {
                                    InventoryRow(item: item)
                                }
                            }
                        }
                        .padding(.top, 16)
                    }
                }
            } else if selectedView == "Map view" {
                // Display Map View using ContentView with inventoryItemsModel
                ContentView().environmentObject(inventoryItemsModel)
                    .onAppear {
                        inventoryItemsModel.startFetching()
                    }
                    .onDisappear {
                        inventoryItemsModel.stopFetching()
                    }
            }
            
            Spacer()
        }
        .navigationTitle("Inventory")
        .onAppear {
            if selectedView == "List view" {
                inventoryItemsModel.startFetching()
            }
        }
        .onDisappear {
            inventoryItemsModel.stopFetching()
        }
    }
}

// Inventory Row
struct InventoryRow: View {
    let item: InventoryItem
    
    var body: some View {
        HStack {
            // Display image if available, else show placeholder
            if let imagePath = item.image,
               let imageURL = URL(string: imagePath) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder while loading
                        ProgressView()
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        // Display the loaded image
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .cornerRadius(8)
                    case .failure:
                        // Show placeholder on failure
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.blue)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Show placeholder if no image is available
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.blue)
                    )
            }
            
            // Item details
            VStack(alignment: .leading) {
                Text(item.equipment_type)
                    .font(.headline)
                Text(item.manufacturer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Navigation arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
