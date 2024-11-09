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
    @State private var showAlert = false
    @ObservedObject var inventoryItemsModel: InventoryItemsModel

    @Binding var showPopup: Bool
    @Binding var tappedItem: InventoryItem?
    
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
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        // Set the delegate
        sceneView.delegate = context.coordinator
        
        // Store sceneView and model in the coordinator
        context.coordinator.sceneView = sceneView

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
        private var cancellable: AnyCancellable?

        // Add properties to handle the alert
        var selectedCoordinate: SCNVector3?
        var alertController: UIAlertController?
        
        init(_ parent: ModelSceneView) {
            self.parent = parent
            super.init()
            self.cancellable = parent.inventoryItemsModel.$items
                .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
                .sink { [weak self] _ in
                    self?.updateRedDots()
                }
        }
        
        deinit {
            cancellable?.cancel()
        }

        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            guard let sceneView = sceneView else { return }
            let touchLocation = gestureRecognize.location(in: sceneView)
            let hitResults = sceneView.hitTest(touchLocation, options: nil)
            
            if let hit = hitResults.first, let nodeName = hit.node.name {
                
                let position = hit.worldCoordinates
                print("Touched position: \(position)")
                
                if let tappedItem = parent.inventoryItemsModel.items.first(where: { $0.id == Int(nodeName)}) {
                    DispatchQueue.main.async {
                        // Set the tapped item to trigger the popup display in SwiftUI
                        self.parent.tappedItem = tappedItem
                        self.parent.showPopup = true
                    }
                }else{
                    presentAlert(at: position)
                }
            } else {
                if let hit = hitResults.first{
                    let position = hit.worldCoordinates
                    // Present the alert
                    presentAlert(at: position)
                }
            }
        }
        
        func presentAlert(at position: SCNVector3) {
            guard let sceneView = sceneView else { return }

            // Remember the selected coordinate
            self.selectedCoordinate = position

            // Create the alert controller
            alertController = UIAlertController(title: "Create Equipment", message: "Do you want to create a new equipment entry here?", preferredStyle: .alert)

            // Add 'Yes' action
            alertController?.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                // Dismiss the alert before navigating
                self.alertController?.dismiss(animated: true, completion: {
                    self.parent.showPopup = false
                    self.navigateToChatView()
                })
            }))

            // Add 'No' action
            alertController?.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                self.alertController?.dismiss(animated: true, completion: nil)
            }))

            // Present the alert
            DispatchQueue.main.async {
                // Find the topmost view controller
                if let topVC = UIApplication.shared.windows.first?.rootViewController {
                    topVC.present(self.alertController!, animated: true, completion: nil)
                }
            }
        }
        
        func navigateToChatView() {
            guard let position = selectedCoordinate else { return }
            let chatView = ChatView() // Initialize your ChatView
            let chatViewController = UIHostingController(rootView: chatView) // Wrap ChatView in a UIHostingController

            DispatchQueue.main.async {
                if let topVC = UIApplication.shared.windows.first?.rootViewController {
                    topVC.present(chatViewController, animated: true, completion: nil)
                }
            }
        }

        
        /*func navigateToCameraView() {
           guard let position = selectedCoordinate else { return }
           guard let sceneView = sceneView else { return }

           // Create the CameraViewController
           let cameraVC = UIHostingController(rootView: CameraView(coordinate: position))

           // Present the CameraViewController
           DispatchQueue.main.async {
               if let vc = sceneView.window?.rootViewController {
                   vc.present(cameraVC, animated: true, completion: nil)
               }
           }
       }*/
        
        func updateRedDots() {
            guard let sceneView = sceneView else { return }
            guard let scene = sceneView.scene else { return }
            
            // Remove existing red dots
            scene.rootNode.enumerateChildNodes { (node, _) in
                if let nodeId = Int(node.name ?? "") {
                        // Check if any item in the list has a matching id
                        if parent.inventoryItemsModel.items.contains(where: { $0.id == nodeId }) {
                            node.removeFromParentNode()
                        }
                    }
            }
            
            // Add red dots for inventory items
            for item in parent.inventoryItemsModel.items {
                let sphere = SCNSphere(radius: 1.3)
                sphere.firstMaterial?.diffuse.contents = UIColor.red
                let node = SCNNode(geometry: sphere)
                node.position = SCNVector3(item.x, item.y, item.z)
                //node.name = "RedDot"
                // Use equipment_type as node's name
                node.name = String(item.id)
                scene.rootNode.addChildNode(node)
            }
        }
    }

    }
