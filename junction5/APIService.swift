//
//  APIService.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation
import SwiftUI
import AVFoundation
import PhotosUI
import SceneKit

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func uploadInventoryItem(image: UIImage, x: Float, y: Float, z: Float, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory") else {
            print("Invalid URL.")
            completion(false)
            return
        }

        // Prepare the image data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            completion(false)
            return
        }

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Generate boundary string
        let boundary = UUID().uuidString

        // Set Content-Type in HTTP header
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create the data
        var body = Data()

        // Add the image data to the raw http request data
        let filename = "image.jpg"
        let mimeType = "image/jpeg"
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        // Add x, y, z fields
        let fields: [String: Float] = ["x": x, "y": y, "z": z]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Close the body with boundary
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading inventory item: \(error)")
                completion(false)
                return
            }

            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    completion(true)
                } else {
                    print("Server returned status code \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("Invalid response from server")
                completion(false)
            }
        }

        task.resume()
    }
    
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

// Extension to append Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}