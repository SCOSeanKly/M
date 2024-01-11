//
//  SnapShot.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        if let data = image.pngData() {
            if let snapshotImage = UIImage(data: data) {
                return snapshotImage
            }
        }
        
        // If for some reason the PNG export fails, return a default image or handle the error as needed.
        return UIImage()
    }
}
