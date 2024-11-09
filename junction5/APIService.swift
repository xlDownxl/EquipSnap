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
    
    func uploadInventoryItem(image: UIImage, x: Float, y: Float, z: Float, completion: @escaping (String?, Int?) -> Void) {
        guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory") else {
            print("Invalid URL.")
            completion("Invalid URL.", nil)
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            completion("Image conversion failed.", nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        let fields: [String: Float] = ["x": x, "y": y, "z": z]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading inventory item: \(error)")
                completion("Failed to upload item.", nil)
                return
            }

            guard let responseData = data else {
                print("No data received")
                completion("No response from server.", nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    let message = json["message"] as? String
                    if let inventory = json["inventory"] as? [String: Any],
                       let inventoryID = inventory["id"] as? Int {
                        completion(message, inventoryID)
                    } else {
                        completion(message, nil)
                    }
                } else {
                    completion("Invalid server response.", nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion("Failed to parse server response.", nil)
            }
        }
        task.resume()
    }
    
    func updateInventoryItem(inventoryID: Int, image: UIImage, x: Float, y: Float, z: Float, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory/\(inventoryID)") else {
            print("Invalid URL.")
            completion("Invalid URL.")
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            completion("Image conversion failed.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        let fields: [String: Float] = ["x": x, "y": y, "z": z]
        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating inventory item: \(error)")
                completion("Failed to update item.")
                return
            }

            guard let responseData = data else {
                print("No data received")
                completion("No response from server.")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    let message = json["message"] as? String
                    completion(message)
                } else {
                    completion("Invalid server response.")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion("Failed to parse server response.")
            }
        }
        task.resume()
    }
                
               
    
    func createInventoryItemText(text: String, completion: @escaping (String?, Int?) -> Void) {
            guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory/text") else {
                print("Invalid URL.")
                completion(nil, nil)
                return
            }

            let body: [String: String] = ["text": text]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                print("Error serializing JSON")
                completion(nil, nil)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error creating inventory item: \(error)")
                    completion(nil, nil)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion(nil, nil)
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String,
                       let inventory = json["inventory"] as? [String: Any],
                       let id = inventory["id"] as? Int {
                        completion(message, id)
                    } else {
                        print("Unexpected JSON format")
                        completion(nil, nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil, nil)
                }
            }

            task.resume()
        }
    
        // Method to update an existing inventory item
        func updateInventoryItemText(id: Int, text: String, completion: @escaping (String?) -> Void) {
            guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory/\(id)/text") else {
                print("Invalid URL.")
                completion(nil)
                return
            }

            let body: [String: String] = ["text": text]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                print("Error serializing JSON")
                completion(nil)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating inventory item: \(error)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }

                if let responseString = String(data: data, encoding: .utf8) {
                    completion(responseString)
                } else {
                    print("Failed to decode response")
                    completion(nil)
                }
            }

            task.resume()
        }
    
    func createInventoryItemWithAudio(audioURL: URL, completion: @escaping (String?, Int?) -> Void) {
        guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory/audio") else {
            print("Invalid URL")
            completion("Invalid URL.", nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set up multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Prepare body
        var body = Data()
        
        // Add audio data to the body
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"audio\"; filename=\"recording.m4a\"\r\n")
        body.append("Content-Type: audio/m4a\r\n\r\n")
        
        do {
            let audioData = try Data(contentsOf: audioURL)
            body.append(audioData)
        } catch {
            print("Failed to read audio data: \(error)")
            completion("Failed to read audio data.", nil)
            return
        }
        
        body.append("\r\n--\(boundary)--\r\n")
        request.httpBody = body
        
        // Perform upload
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading audio: \(error)")
                completion("Failed to upload audio.", nil)
                return
            }
            
            guard let responseData = data else {
                print("No data received")
                completion("No response from server.", nil)
                return
            }
            
            do {
                // Parse the JSON response to get the "message" and "inventory" fields
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    let message = json["message"] as? String
                    
                    // Cast "inventory" to a dictionary before accessing "id"
                    if let inventory = json["inventory"] as? [String: Any],
                       let inventoryID = inventory["id"] as? Int {
                        completion(message, inventoryID)
                    } else {
                        completion(message, nil)
                    }
                } else {
                    print("Unexpected JSON format")
                    completion("Invalid server response.", nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion("Failed to parse server response.", nil)
            }
        }
        
        task.resume()
    }
    
    func uploadAudioFile(inventoryID: Int, audioURL: URL, completion: @escaping (String?) -> Void) {
            guard let url = URL(string: "http://granlund.lorenso.nl/api/inventory/\(inventoryID)/audio") else {
                print("Invalid URL")
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set up multipart form data
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // Prepare body
            var body = Data()
            
            // Add audio data to the body
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"audio\"; filename=\"recording.m4a\"\r\n")
            body.append("Content-Type: audio/m4a\r\n\r\n")
            
            do {
                let audioData = try Data(contentsOf: audioURL)
                body.append(audioData)
            } catch {
                print("Failed to read audio data: \(error)")
                completion(nil)
                return
            }
            
            body.append("\r\n--\(boundary)--\r\n")
            request.httpBody = body
            
            // Perform upload
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error uploading audio: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                do {
                    // Parse the JSON response to get the "message" field
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        completion(message)
                    } else {
                        print("Unexpected JSON format")
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
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
