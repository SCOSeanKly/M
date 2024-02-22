//
//  GradientOverlayImageView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct GradientOverlayImageView: View {
    
    @Binding var importedImageOverlay: UIImage?
    
    var body: some View {
        if let imageOverlay = importedImageOverlay {
            Image(uiImage: imageOverlay)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .shadow(radius: 5, x: 3)
        }
    }
}
