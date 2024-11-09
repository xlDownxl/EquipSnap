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
    let material: String
    let manufacturer: String
    let model: String
    let serial_number: String
    let last_check: String
    let ai_comments: String
    let condition: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case x
        case y
        case z
        case equipment_type
        case material
        case manufacturer
        case model
        case serial_number
        case last_check
        case ai_comments
        case condition
        case image
    }
    
    // Custom initializer with default values for missing fields
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int.self, forKey: .id)
            x = try container.decodeIfPresent(Float.self, forKey: .x) ?? 0.0
            y = try container.decodeIfPresent(Float.self, forKey: .y) ?? 0.0
            z = try container.decodeIfPresent(Float.self, forKey: .z) ?? 0.0
            
            // Decode each optional property with a default value
            equipment_type = try container.decodeIfPresent(String.self, forKey: .equipment_type) ?? "Unknown"
            material = try container.decodeIfPresent(String.self, forKey: .material) ?? "N/A"
            manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer) ?? "N/A"
            model = try container.decodeIfPresent(String.self, forKey: .model) ?? "N/A"
            serial_number = try container.decodeIfPresent(String.self, forKey: .serial_number) ?? "N/A"
            last_check = try container.decodeIfPresent(String.self, forKey: .last_check) ?? "N/A"
            ai_comments = try container.decodeIfPresent(String.self, forKey: .ai_comments) ?? "No comments"
            condition = try container.decodeIfPresent(String.self, forKey: .condition) ?? "N/A"
            let image_tmp = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
            if image_tmp == "" {
                image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ficon-library.com%2Fimages%2Fno-image-icon%2Fno-image-icon-13.jpg&f=1&nofb=1&ipt=34478d9d5dfd08808a0127536a85364eff26467164443f558b83007928d13d7e&ipo=images"
            }else{
                image = "http://granlund.lorenso.nl/storage" + image_tmp
            }
        }
}

