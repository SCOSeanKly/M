//
//  UIImage.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

extension UIImage {
    func writeToPhotosAlbum() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    func combineWithOverlay(_ overlayImage: UIImage, screenSize: CGSize) -> UIImage {
        let size = CGSize(width: screenSize.width, height: screenSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        self.draw(in: CGRect(origin: .zero, size: size))
        overlayImage.draw(in: CGRect(origin: .zero, size: size))
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage ?? self
    }
}
