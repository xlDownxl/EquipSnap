//
//  ChatView.swift
//  junction5
//
//  Created by Lorenso D'Agostino on 09/11/2024.
//
import SceneKit

import SwiftUI
import Combine
import Foundation
import AVFoundation

// Model for a Chat Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// View Model for managing chat logic
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Hi, I’m here to assist you to create inventory for the room. Start with taking a few photos for one device and upload in bulk.", isUser: false)
    ]
    @Published var messageText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var inventoryItemId: Int? // Stores the ID of the created inventory item
    
    private var audioRecorder: AVAudioRecorder?
    private var audioFilename: URL?
    public var isRecording = false
    
    let position: SCNVector3?

    init(position: SCNVector3?) {
        self.position = position
        
    }
    
    
   /* private var x = Float
    private var y = Float
    private var z = Float
    */
    func sendMessage() {
        // Add user message to chat
        let userMessage = ChatMessage(text: messageText, isUser: true)
        messages.append(userMessage)
        
        // Add a loading message
        let loadingMessage = ChatMessage(text: "Sending...", isUser: false)
        messages.append(loadingMessage)
        
        if let id = inventoryItemId {
            // If inventory item ID is known, update the existing item
            APIService.shared.updateInventoryItemText(id: id, text: messageText) { [weak self] response in
                DispatchQueue.main.async {
                    // Remove loading message
                    self?.messages.removeLast()
                    
                    if let responseText = response {
                        let responseMessage = ChatMessage(text: responseText, isUser: false)
                        self?.messages.append(responseMessage)
                    } else {
                        let errorMessage = ChatMessage(text: "Failed to receive response.", isUser: false)
                        self?.messages.append(errorMessage)
                    }
                    
                    // Clear the message input
                    self?.messageText = ""
                }
            }
        } else {
            // If inventory item ID is not known, create a new inventory item
            APIService.shared.createInventoryItemText(text: messageText) { [weak self] response, id in
                DispatchQueue.main.async {
                    // Remove loading message
                    self?.messages.removeLast()
                    
                    if let responseText = response {
                        let responseMessage = ChatMessage(text: responseText, isUser: false)
                        self?.messages.append(responseMessage)
                        
                        // Store the inventory item ID for future updates
                        self?.inventoryItemId = id
                    } else {
                        let errorMessage = ChatMessage(text: "Failed to receive response.", isUser: false)
                        self?.messages.append(errorMessage)
                    }
                    
                    // Clear the message input
                    self?.messageText = ""
                }
            }
        }
    }
    
    
    // Method to start recording audio
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            // Set the audio file path
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFilename = documentsDirectory.appendingPathComponent("recording.m4a")
            
            // Recording settings
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            isRecording = true
            print("Recording started")
        } catch {
            print("Failed to set up audio session or start recording: \(error)")
            isRecording = false
        }
    }
    
    // Method to stop recording audio and upload it
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        guard let audioURL = audioFilename, let id = inventoryItemId else {
            print("No audio file or inventory item ID available")
            return
        }
        
        // Display a message indicating the audio is being sent
        messages.append(ChatMessage(text: "Sending audio...", isUser: true))
        
        // Use APIService to upload the audio file
        APIService.shared.uploadAudioFile(inventoryID: id, audioURL: audioURL) { [weak self] responseMessage in
            DispatchQueue.main.async {
                // Remove the "Sending audio..." message
                self?.messages.removeLast()
                
                if let responseText = responseMessage {
                    self?.messages.append(ChatMessage(text: "Audio message sent", isUser: true))
                    // Display the API's response message in the chat
                    self?.messages.append(ChatMessage(text: responseText, isUser: false))
                } else {
                    // If no message is returned, display an error message
                    self?.messages.append(ChatMessage(text: "Failed to send audio message", isUser: false))
                }
            }
        }
    }
    
    func handleImageCapture(_ image: UIImage) {
        // Display a message indicating the audio is being sent
        messages.append(ChatMessage(text: "Image sent", isUser: true))
        // Display a message indicating the audio is being sent
        messages.append(ChatMessage(text: "Processing image...", isUser: false))
        
        if let id = inventoryItemId {
            // Update existing inventory item
            var xPosition: Float { position?.x ?? -500}
            var yPosition: Float {  position?.y ?? -500}
            var zPosition: Float {position?.z ?? -500}
            APIService.shared.updateInventoryItem(inventoryID: id, image: image, x: xPosition, y: yPosition, z: zPosition) { [weak self] responseMessage in
                DispatchQueue.main.async {
                    self?.messages.removeLast()
                    
                    if let message = responseMessage {
                        self?.messages.append(ChatMessage(text: message, isUser: false))
                    } else {
                        self?.messages.append(ChatMessage(text: "Failed to update inventory item.", isUser: false))
                    }
                }
            }
        } else {
            // Create new inventory item
            var xPosition: Float { position?.x ?? -500}
            var yPosition: Float {  position?.y ?? -500}
            var zPosition: Float {position?.z ?? -500}
            APIService.shared.uploadInventoryItem(image: image, x: xPosition, y: yPosition, z: zPosition) { [weak self] responseMessage, newInventoryID in
                DispatchQueue.main.async {
                    self?.messages.removeLast()
                    
                    if let message = responseMessage {
                        self?.messages.append(ChatMessage(text: message, isUser: false))
                        // Store the inventory item ID for future updates
                        if let id = newInventoryID {
                            self?.inventoryItemId = id
                        }
                    } else {
                        self?.messages.append(ChatMessage(text: "Failed to create inventory item.", isUser: false))
                    }
                }
            }
        }
    }
    
//    func handleImageCapture(_ image: UIImage) {
//        // Display a message indicating the audio is being sent
//        messages.append(ChatMessage(text: "Image sent", isUser: true))
//        // Display a message indicating the audio is being sent
//        messages.append(ChatMessage(text: "Processing image...", isUser: false))
//        
//        if let id = inventoryItemId {
//            // Update existing inventory item
//            APIService.shared.updateInventoryItem(inventoryID: id, image: image, x: 0.0, y: 0.0, z: 0.0) { [weak self] success in
//                DispatchQueue.main.async {
//                    self?.messages.removeLast()
//                    
//                    if success {
//                        self?.messages.append(ChatMessage(text: "Inventory item updated successfully.", isUser: false))
//                    } else {
//                        self?.messages.append(ChatMessage(text: "Failed to update inventory item.", isUser: false))
//                    }
//                }
//            }
//        } else {
//            // Create new inventory item
//            APIService.shared.uploadInventoryItem(image: image, x: 0.0, y: 0.0, z: 0.0) { [weak self] success in
//                DispatchQueue.main.async {
//                    self?.messages.removeLast()
//                    
//                    if success {
//                        self?.messages.append(ChatMessage(text: "Inventory item created successfully.", isUser: false))
//                        // Optionally, store the inventory ID if returned from the API
//                        // self?.inventoryItemId = <receivedInventoryID>
//                    } else {
//                        self?.messages.append(ChatMessage(text: "Failed to create inventory item.", isUser: false))
//                    }
//                }
//            }
//        }
//    }
}

struct ChatView: View {
    @State private var messageText: String = ""
    @StateObject private var viewModel: ChatViewModel

    // Update initializer to take `position` and initialize `viewModel`
    init(position: SCNVector3?) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(position: position))
    }
    // State for camera
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Button(action: {
                    // Back action here
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Text("Adding inventory")
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    // Details action here
                }) {
                    Text("Details")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Divider()
            
            //                    // Chat Area
            //                    ScrollView {
            //                        VStack(alignment: .leading, spacing: 10) {
            //                            // Chat Bubble
            //                            HStack(alignment: .top) {
            //                                Circle()
            //                                    .fill(Color.gray.opacity(0.5))
            //                                    .frame(width: 40, height: 40)
            //
            //                                Text("Hi, I’m here to assist you to create inventory for the room. Start with taking a few photos for one device and upload in bulk.")
            //                                    .padding()
            //                                    .background(Color.blue.opacity(0.1))
            //                                    .cornerRadius(15)
            //                                    .frame(maxWidth: .infinity, alignment: .leading)
            //                            }
            //                            .padding(.horizontal)
            //                        }
            //                        .padding(.top)
            //                    }
            // Chat messages area
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                TextBubble(text: message.text, isUser: true)
                            } else {
                                TextBubble(text: message.text, isUser: false)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            
            Spacer()
            
            // Message Input Area
            HStack(spacing: 12) {
                // Camera Icon
                Button(action: {
                    showImagePicker = true // Open the camera
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showImagePicker) {
                    CameraImagePicker(sourceType: .camera, selectedImage: $selectedImage, onDismiss: handleImageSelection)
                }
                
                Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .onLongPressGesture(
                        minimumDuration: 0.1, // Adjust the duration if needed
                        pressing: { isPressing in
                            if isPressing {
                                viewModel.startRecording() // Start recording when pressed down
                            } else {
                                viewModel.stopRecording() // Stop recording when released
                            }
                        },
                        perform: {}
                    )
                
                // Text Field
                TextField("Message", text: $viewModel.messageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                
                // Send Button
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(45))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleImageSelection() {
        guard let image = selectedImage else { return }
        viewModel.handleImageCapture(image)
    }
}

// Custom chat bubble view
struct TextBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        Text(text)
            .padding()
            .background(isUser ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(15)
            .frame(maxWidth: 250, alignment: isUser ? .trailing : .leading)
    }
}

struct CameraImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    var onDismiss: () -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraImagePicker>) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.onDismiss()
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onDismiss()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

#Preview {
   // ChatView()
}
