//
//  OverlaysView.swift
//  M
//
//  Created by Sean Kelly on 11/03/2024.
//

import SwiftUI

struct OverlaysView: View {
    
    @Binding var selectedURLOverlayImages: [ImageModelOverlayImage]
    @Binding var importedImageOverlay: UIImage?
    @Binding var blendModeEffects: BlendMode
    @Binding var effectsOpacity: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(selectedURLOverlayImages) { image in
                OverlaysImageView(image: image, effectsOpacity: $effectsOpacity, blendModeEffects: $blendModeEffects)
                
            }
        }
        .background(Color.clear)
    }
}

