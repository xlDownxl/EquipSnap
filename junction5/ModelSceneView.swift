//
//  ModelSceneView.swift
//  junction5
//
//  Created by Joswig, Niclas on 9.11.2024.
//

import SwiftUI
import SceneKit
import Combine

struct ModelSceneView: UIViewRepresentable {
    @Binding var selectedCoordinate: SCNVector3?
    var savedCoordinatesModel: SavedCoordinatesModel

    
    func makeUIView(context: Context) -> SCNView {
        // Initialize the SCNView
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true // Enable user interaction
        //sceneView.backgroundColor = UIColor.gray // Set background color

        
        
        
        // Load the USDZ model
        guard let scene = SCNScene(named: "building_meters.usdz") else {
            print("Failed to load the model")
            return sceneView
        }
        
        // Make all materials double-sided
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.geometry?.materials.forEach { material in
                material.isDoubleSided = true
            }
        }

        // **Add Lighting**
            // Create and add an ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 500
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        // Create and add a directional light
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.eulerAngles = SCNVector3Make(-.pi / 3, 0, 0)
        scene.rootNode.addChildNode(directionalLightNode)
        
        sceneView.scene = scene
        
        // **Create a custom camera node**
      /*  let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // **Compute the center of the model to set as the target**
        let (minVec, maxVec) = scene.rootNode.boundingBox
        let center = SCNVector3(
            (minVec.x + maxVec.x) / 2,
            (minVec.y + maxVec.y) / 2,
            (minVec.z + maxVec.z) / 2
        )
        
        // **Set the camera position**
        cameraNode.position = SCNVector3(center.x, center.y, center.z + 10) // Adjust z+10 as needed
        scene.rootNode.addChildNode(cameraNode)
        
        // **Set the custom camera as the pointOfView**
         sceneView.pointOfView = cameraNode
         
         // **Set the camera controller's target to the center of the model**
         sceneView.defaultCameraController.target = center
       
       */
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        // Set the delegate
        sceneView.delegate = context.coordinator
        
        // Store sceneView and model in the coordinator
        context.coordinator.sceneView = sceneView
        context.coordinator.savedCoordinatesModel = savedCoordinatesModel

        // Initial update of red dots
        context.coordinator.updateRedDots()
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // This method can be used to update the view when state changes
        context.coordinator.updateRedDots()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle gestures and events
    class Coordinator: NSObject, SCNSceneRendererDelegate {
            var parent: ModelSceneView
            var sceneView: SCNView?
            var savedCoordinatesModel: SavedCoordinatesModel

            init(_ parent: ModelSceneView) {
                self.parent = parent
                self.savedCoordinatesModel = parent.savedCoordinatesModel
                super.init()
                // Add observer for 'CoordinateSaved' notification
                NotificationCenter.default.addObserver(self, selector: #selector(coordinateSaved), name: NSNotification.Name("CoordinateSaved"), object: nil)
            }

            deinit {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name("CoordinateSaved"), object: nil)
            }

            @objc func coordinateSaved() {
                updateRedDots()
            }

        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
                    guard let sceneView = sceneView else { return }
                    let touchLocation = gestureRecognize.location(in: sceneView)
                    let hitResults = sceneView.hitTest(touchLocation, options: [:])
                    if let hit = hitResults.first {
                        let position = hit.worldCoordinates
                        print("Touched position: \(position)")

                        DispatchQueue.main.async {
                            // Set the selected coordinate to trigger navigation
                            self.parent.selectedCoordinate = position
                        }
                    } else {
                        print("No hit detected")
                    }
                }

            func updateRedDots() {
                guard let sceneView = sceneView else { return }
                guard let scene = sceneView.scene else { return }

                // Remove existing red dots
                scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "RedDot" {
                        node.removeFromParentNode()
                    }
                }

                // Add red dots for saved coordinates
                for coordinate in savedCoordinatesModel.coordinates {
                    let sphere = SCNSphere(radius: 0.1)
                    sphere.firstMaterial?.diffuse.contents = UIColor.red
                    let node = SCNNode(geometry: sphere)
                    node.position = coordinate
                    node.name = "RedDot"
                    scene.rootNode.addChildNode(node)
                }
            }
        }
    }
