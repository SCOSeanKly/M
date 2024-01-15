//
//  DataModel.swift
//  M
//
//  Created by Sean Kelly on 07/12/2023.
//

import SwiftUI

class DataViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var forceRefresh: Bool = false {
        didSet {
            if forceRefresh {
                loadImages()
            }
        }
    }
    
    @Published var creatorName: String = "SeanKly"
    @AppStorage("seenImages") var seenImages: [String] = []
    @Published var newImagesCount: Int = 0
    
    private let commonBaseUrl = "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main"

    private let creatorURLs: [String: (subPath: String, jsonFile: String)] = [
        "widgy": (
            subPath: "/Widgys/",
            jsonFile: "/JSON/widgyImages.json"
        ),
        "SeanKly": (
            subPath: "/Wallpapers/",
            jsonFile: "/JSON/wallpaperImages.json"
        ),
        "ElijahCreative": (
            subPath: "/elijahCreative_Wallpapers/",
            jsonFile: "/JSON/elijahCreative.json"
        ),
        "timetravelr2025": (
            subPath: "/timetravelr2025_Wallpapers/",
            jsonFile: "/JSON/timetravelr2025.json"
        )
    ]

    func loadImages() {
        guard let urls = creatorURLs[creatorName] else {
            return
        }
        
        let baseUrlString = commonBaseUrl + urls.subPath
        let urlString = commonBaseUrl + urls.jsonFile
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let imageNames = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    
                    let newImages = imageNames.filter { imageName in
                        !self.seenImages.contains(imageName)
                    }
                    
                    self.newImagesCount = newImages.count
                    
                    self.images = imageNames.indices.map { index in
                        let imageName = imageNames[index]
                        let imageUrlString = baseUrlString + imageName
                        var image = ImageModel(image: imageUrlString)
                        
                        // Check if the base name of the image has been seen before
                        let isNew = !self.seenImages.contains(image.baseName)
                        
                        // If it's a new image, mark it as seen
                        if isNew {
                            self.seenImages.append(image.baseName)
                        }
                        
                        image.isNew = isNew
                        
                        return image
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
