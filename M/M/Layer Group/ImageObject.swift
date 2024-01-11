//
//  ImageObject.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


class Object: LayerObject {
    
    
    // MARK: - Public Properties
    
    
    // MARK: - Public Methods
    
    
    init(id: UUID = UUID(), appearance: LayerObjectAppearance = LayerObjectAppearance()) {
        
        super.init()
        self.id = id
        self.appearance = appearance
    
    }
}
