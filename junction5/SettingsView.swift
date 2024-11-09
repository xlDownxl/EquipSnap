//
//  SettingsView.swift
//  junction5
//
//  Created by Vili-Sakari Kelo on 9.11.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            Text("Here you can adjust your settings.")
                .font(.body)
                .padding()

            Spacer()
        }
        //.navigationTitle("Settings")
    }
}
