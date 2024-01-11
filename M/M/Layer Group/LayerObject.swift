//
//  LayerObject.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import Foundation

class LayerObject: Identifiable, ObservableObject {
    
    
    // MARK: - Public properties
    
    
    /// The unique identifier of the object
    var id = UUID()
    
    /// The class which defines the objects appearance on the screen
    @Published var appearance: LayerObjectAppearance = .init()
     
}
