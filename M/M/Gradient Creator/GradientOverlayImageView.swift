//
//  GradientOverlayImageView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct GradientOverlayImageView: View {
    
    @Binding var importedImageOverlay: UIImage?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
  
    var body: some View {
        ZStack {
            if let imageOverlay = importedImageOverlay {
                Image(uiImage: imageOverlay)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth, height: screenHeight)
                    .clipShape(Rectangle())
            }
        }
        .background(Color.clear)
    }
}
