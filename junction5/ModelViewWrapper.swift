//
//  ModelViewWrapper.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import SwiftUI
import SceneKit

extension SCNVector3: Equatable {
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

struct ModelViewWrapper: View {
    @EnvironmentObject var savedCoordinatesModel: SavedCoordinatesModel
    @State private var navigateToCoordinateView = false
    @State private var selectedCoordinate: SCNVector3?

    var body: some View {
        ZStack {
            ModelSceneView(selectedCoordinate: $selectedCoordinate, savedCoordinatesModel: savedCoordinatesModel)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: selectedCoordinate) { newValue in
                    if newValue != nil {
                        navigateToCoordinateView = true
                    }
                }

            NavigationLink(
                           destination: CoordinateView(coordinate: selectedCoordinate ?? SCNVector3Zero)
                               .environmentObject(savedCoordinatesModel), // Pass the environment object here
                           isActive: $navigateToCoordinateView
                       ) {
                           EmptyView()
                       }
        }
    }
}

#Preview {
    ModelViewWrapper().environmentObject(SavedCoordinatesModel())
}
