//
//  junction5App.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import SwiftUI

@main
struct junction5App: App {
    @StateObject var inventoryItemsModel = InventoryItemsModel()
    
    var body: some Scene {
        WindowGroup {

        /*    ContentView() .environmentObject(inventoryItemsModel)
                .onAppear {
                    inventoryItemsModel.startFetching()
                }*/

            WelcomeView()

        }
    }
}
