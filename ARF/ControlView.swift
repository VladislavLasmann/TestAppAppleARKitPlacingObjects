//
//  ControlView.swift
//  ARF
//
//  Created by Vladi on 03.07.22.
//

import SwiftUI
import RealityKit


struct ControlView: View {
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var currentModelEntity: ModelEntity
    
    var body: some View {
        VStack {
            
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible {
                ControlButtonBar(showBrowse: $showBrowse, currentModelEntity: $currentModelEntity)
            }
            
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var isControlVisible: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                Color.black.opacity(0.25)
                
                Button(action: {
                    print("Control Visibillity Toggle Button pressed.")
                    self.isControlVisible.toggle()
                }) {
                    Image(systemName: self.isControlVisible ? "rectangle" :
                    "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
}


struct ControlButtonBar: View {
    @Binding var showBrowse: Bool
    @Binding var currentModelEntity: ModelEntity
    
    var body: some View {
        HStack {
            /*
            // Force button
            ControlButton(systemIconName: "arrow.up") {
                currentModelEntity.setPosition(simd_float3(30, 30, 30), relativeTo: currentModelEntity)
                
                print("Force button pressed \(currentModelEntity.name)")
            }
             */
            Spacer()
            
            // Browse Button
            ControlButton(systemIconName: "square.grid.2x2") {
                print("Browse button pressed")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                // Browse View
                BrowseView(showBrowse: $showBrowse)
            })
            
            Spacer()
            /*
            // Rotate Button
            ControlButton(systemIconName: "rotate.right.fill") {
                print("Rotate button pressed")
            }*/
            
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color.black.opacity(0.25))
    }
}


struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {self.action()}) {
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
    }
    
    
    
}
