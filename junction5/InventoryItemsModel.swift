//
//  InventoryItemsModel.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation
import Combine

class InventoryItemsModel: ObservableObject {
    @Published var items: [InventoryItem] = []
    
    private var timer: Timer?
    
    func startFetching() {
        fetchItems()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchItems()
        }
    }
    
    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchItems() {
        APIService.shared.fetchInventoryItems { [weak self] items in
            DispatchQueue.main.async {
                self?.items = items
            }
        }
    }
}
