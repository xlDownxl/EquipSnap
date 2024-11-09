//
//  ContentView.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ModelSceneView()
            .edgesIgnoringSafeArea(.all) // Optional: Make the model view full screen
    }
}

#Preview {
    ContentView()
}
