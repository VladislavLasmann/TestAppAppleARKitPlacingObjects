//
//  ContentView.swift
//  ARF
//
//  Created by Vladi on 03.07.22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var currentModelEntity: ModelEntity = ModelEntity()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(currentModelEntity: $currentModelEntity)
            
            
            if self.placementSettings.selectedModel == nil {
                ControlView(isControlVisible: $isControlsVisible, showBrowse: $showBrowse, currentModelEntity: $currentModelEntity)
            } else {
                PlacementView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var currentModelEntity: ModelEntity
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        // Subscribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            
            self.updateScene(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
    
    private func updateScene(for arView: CustomARView) {
        // Only displace focusEntity when user has selected a model for placemnt
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        // add model to scene if confirmed for placement
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            self.place(modelEntity, in: arView)
            
            self.currentModelEntity = modelEntity
            
            self.placementSettings.confirmedModel = nil
            
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        // 1. clone model. This creates an identical copy of model entity and refrences the same model. This allows to have multiple models of the same asset in the scene
        let clonedEntity = modelEntity.clone(recursive: true)
        
        // 2. enable translation and rotation gestures
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // 3. create an anchorEntity and add clonedEntity to the anchorEntity
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        // 4. add the anchor entity to the arview.scene
        arView.scene.addAnchor(anchorEntity)
        
        print("Added modelEntity to scene.")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
