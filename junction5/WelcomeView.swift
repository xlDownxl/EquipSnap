//
//  WelcomeView.swift
//  junction5
//
//  Created by Lorenso D'Agostino on 09/11/2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            // Placeholder Image (Center)
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.blue.opacity(0.5)) // Adjust color to match placeholder
                .background(Color.blue.opacity(0.1)) // Light blue background
                .cornerRadius(10)
                .padding(.bottom, 50)
            
            Spacer()
            
            // Welcome Text
            VStack(alignment: .leading, spacing: 10) {
                Text("Hi Heikki,")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("welcome back to EquipSnap!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            
            // Next Button with Navigation
                            NavigationLink(destination: ContentView()) {
                                Text("Next")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            .padding(.bottom, 30)
            
            // Next Button
            Button(action: {
                // Action for Next Button (e.g., navigate to another screen)
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .background(Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)) // Light blue background for the whole screen
    }
}

#Preview {
    WelcomeView()
}
