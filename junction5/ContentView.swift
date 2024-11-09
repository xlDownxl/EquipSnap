//
//  ContentView.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var savedCoordinatesModel = SavedCoordinatesModel()
    
    var body: some View {
        NavigationView {
            ModelViewWrapper()
                .edgesIgnoringSafeArea(.all)
                .environmentObject(savedCoordinatesModel)
        }
    }
}

#Preview {
    ContentView()
}

