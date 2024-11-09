import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: InventoryListView()) {
                    Text("Add Inventory")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Main View")
        }
    }
}

struct InventoryListView: View {
    @State private var inventoryItems: [String] = [] // A simple list of strings for inventory items
    @State private var newItem: String = ""

    var body: some View {
        VStack {
            if inventoryItems.isEmpty {
                Text("No items in inventory.")
                    .font(.subheadline)
                    .padding()
            } else {
                List {
                    ForEach(inventoryItems, id: \.self) { item in
                        Text(item)
                    }
                }
            }

            HStack {
                TextField("Enter new item", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: addItem) {
                    Text("Add")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Inventory")
    }

    private func addItem() {
        guard !newItem.isEmpty else { return }
        inventoryItems.append(newItem)
        newItem = "" // Clear the text field
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
