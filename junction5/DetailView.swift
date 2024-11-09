import SwiftUI

struct DetailView: View {
    var item: InventoryItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Item Image
                AsyncImage(url: URL(string: item.image ?? "fallback")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Header with title and ID
                VStack(alignment: .leading) {
                    Text(item.equipment_type)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("ID \(item.id)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Condition Question and Tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("What condition is the device?")
                        .font(.headline)
                    
                    // Tags for different conditions
                    HStack {
                        ForEach(["GOOD CONDITION"], id: \.self) { condition in
                            Text(condition)
                                .font(.footnote)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                
                // Item Attributes
                VStack(alignment: .leading, spacing: 16) {
                    Text("Equipment Type: \(item.equipment_type)")
                    Text("Material: \(item.material)")
                    Text("Manufacturer: \(item.manufacturer)")
                    Text("Model: \(item.model)")
                    Text("Serial Number: \(item.serial_number)")
                    Text("Last Check: \(item.last_check)")
                    Text("AI Comments: \(item.ai_comments)")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                NavigationLink(destination: ChatView(position: nil, inventoryItemId: item.id)) {
                    Text("Make Edits")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
