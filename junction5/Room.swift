//
//  Room.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation

struct Room: Codable {
    let id: Int
    let inventory_items: [InventoryItem]
}
