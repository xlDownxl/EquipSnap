//
//  APIService.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchInventoryItems(completion: @escaping ([InventoryItem]) -> Void) {
        guard let url = URL(string: "http://granlund.lorenso.nl/api/rooms") else {
            print("Invalid URL.")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching inventory items: \(error)")
                completion([])
                return
            }
            guard let data = data else {
                print("No data received.")
                completion([])
                return
            }
            
            do {
                // Since the response is a list of rooms, each containing inventory_items
                let rooms = try JSONDecoder().decode([Room].self, from: data)
                // Extract inventory items from all rooms
                let items = rooms.flatMap { $0.inventory_items }
                completion(items)
            } catch {
                print("Error parsing inventory items: \(error)")
                completion([])
            }
        }
        task.resume()
    }
}
