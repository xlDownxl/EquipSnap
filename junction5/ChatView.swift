//
//  ChatView.swift
//  junction5
//
//  Created by Lorenso D'Agostino on 09/11/2024.
//

import SwiftUI
import Combine

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
    
    func sendMessage() {
        // Add user message to chat
        let userMessage = ChatMessage(text: messageText, isUser: true)
        messages.append(userMessage)
        
        // Add a loading message
        let loadingMessage = ChatMessage(text: "Sending...", isUser: false)
        messages.append(loadingMessage)
        
        // Send API request
        APIService.shared.sendTextMessage(text: messageText) { [weak self] response in
            DispatchQueue.main.async {
                // Remove loading message
                self?.messages.removeLast()
                
                // Display the API response message in the chat
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
     }
    
//    private func fetchResponse(for message: String) {
//        // Mock API call
//        Just("This is a response to your message: '\(message)'")
//            .delay(for: .seconds(1), scheduler: DispatchQueue.main) // Simulate network delay
//            .sink { [weak self] response in
//                let responseMessage = ChatMessage(text: response, isUser: false)
//                self?.messages.append(responseMessage)
//            }
//            .store(in: &cancellables)
//    }
}

struct ChatView: View {
    @State private var messageText: String = ""
    @StateObject private var viewModel = ChatViewModel()

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
                            // Camera action
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        
                        // Chat Icon
                        Button(action: {
                            // Chat action
                        }) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        
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
                .edgesIgnoringSafeArea(.bottom)
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

#Preview {
    ChatView()
}
