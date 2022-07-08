//
//  Model.swift
//  ARF
//
//  Created by Vladi on 03.07.22.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case cars
    case buildings
    
    
    var label: String {
        get {
            switch self {
            case .cars:
                return "Cars"
            case .buildings:
                return "Buildings"
            }
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                
            }) { modelEntity in
                
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded.")
            }
    }
}


struct Models {
    var all: [Model] = []
    
    init() {
        // Cars
        let audiRs8 = Model(name: "2018_Audi_TT_RS", category: .cars, scaleCompensation: 0.01)
        let toyotaGRSupra = Model(name: "Toyota_GR_Supra", category: .cars, scaleCompensation: 0.01)
        let astonMartinVanquish = Model(name: "Aston_Martin_Vanquish", category: .cars, scaleCompensation: 0.01)
        self.all += [audiRs8, toyotaGRSupra, astonMartinVanquish]
        
        // Buildings
        let buildingResidential = Model(name: "Residential_Building_Set", category: .buildings, scaleCompensation: 1)
        self.all += [buildingResidential]
    }
    
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
}
