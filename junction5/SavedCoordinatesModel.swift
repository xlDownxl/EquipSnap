//
//  SavedCoordinatesModel.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import Foundation
import SceneKit
import Combine

class SavedCoordinatesModel: ObservableObject {
    @Published var coordinates: [SCNVector3] = []
}

