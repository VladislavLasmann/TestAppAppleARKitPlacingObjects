//
//  ARFApp.swift
//  ARF
//
//  Created by Vladi on 03.07.22.
//

import SwiftUI

@main
struct ARFApp: App {
    @StateObject var placementSettings = PlacementSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}
