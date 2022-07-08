//
//  PlacementSettings.swift
//  ARF
//
//  Created by Vladi on 04.07.22.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    // When user selectes model in BrowseView, property is set
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selected model to \(String(describing: newValue?.name))")
        }
    }
    
    // When user taps confirm in placementView, value of selectedModel is assigned to confirmedModel
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmed Model")
                return
            }
            
            print("Setting confirmed model to \(model.name)")
        }
    }
    
    // this property retains the cancellable object for our SceneEvents.Update subscriber
    var sceneObserver: Cancellable?
}
