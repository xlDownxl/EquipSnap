//
//  InventoryView.swift
//  junction5
//
//  Created by Vili-Sakari Kelo on 9.11.2024.
//
import SwiftUI
import SceneKit

struct InventoryView: View {
    @State private var selectedView: String = "List view"
    @StateObject var inventoryItemsModel = InventoryItemsModel()

    var body: some View {
        VStack {
            // Map view and List view toggle
            Picker("View Selection", selection: $selectedView) {
                Text("Map view").tag("Map view")
                Text("List view").tag("List view")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Conditional content rendering based on selected view
            if selectedView == "List view" {
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

                    Text("You can create inventory by clicking the button below, or adding from map view to load location data.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    Button(action: {
                        // Add inventory button action (no functionality needed for now)
                    }) {
                        Text("Add inventory")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 50)
                    }

                    Spacer()
                }
            } else if selectedView == "Map view" {
                // Integrating the ModelViewWrapper
                ContentView().environmentObject(inventoryItemsModel)                     .onAppear {
                         inventoryItemsModel.startFetching()
                     }
            }

            Spacer()

            // Bottom navigation bar placeholder
            HStack {
                Spacer()
                Button(action: {
                    // No functionality needed for Profile button yet
                }) {
                    VStack {
                        Image(systemName: "person.circle")
                        Text("Profile")
                            .font(.footnote)
                    }
                    .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .navigationTitle("Inventory")
    }
}