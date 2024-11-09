//
//  InventoryItem.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation

struct InventoryItem: Identifiable, Codable {
    let id: Int
    let x: Float
    let y: Float
    let z: Float
    let equipment_type: String

    enum CodingKeys: String, CodingKey {
        case id
        case x
        case y
        case z
        case equipment_type
    }
}
