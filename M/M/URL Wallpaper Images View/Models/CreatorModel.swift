//
//  CreatorModel.swift
//  M
//
//  Created by Sean Kelly on 22/03/2024.
//

import SwiftUI

struct CreatorModel {
    let name: String
    var totalImagesCount: Int
    var newImagesCount: Int = 0
    let imageURL: URL

    mutating func loadNewImages(imageNames: [String]) {
        let seenImages = UserDefaults.standard.array(forKey: "\(name)_seenImages") as? [String] ?? []

        let newImages = imageNames.filter { imageName in
            !seenImages.contains(imageName)
        }
        newImagesCount = newImages.count

        var updatedSeenImages = seenImages
        updatedSeenImages.append(contentsOf: newImages)

        UserDefaults.standard.set(updatedSeenImages, forKey: "\(name)_seenImages")
    }

    func resetSeenImages() {
        UserDefaults.standard.removeObject(forKey: "\(name)_seenImages")
    }
}
