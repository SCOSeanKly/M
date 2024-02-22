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
    
    private let commonBaseUrl = "https://raw.githubusercontent.com/SCOSeanKly/"
    
    private let creatorURLs: [String: (subPath: String, jsonFile: String)] = [
        "widgy": (
            subPath: "M_Resources/main/Widgys/",
            jsonFile: "M_Resources/main/JSON/widgyImages.json"
        ),
        "SeanKly": (
            subPath: "M_Resources/main/Wallpapers/",
            jsonFile: "M_Resources/main/JSON/wallpaperImages.json"
        ),
        "ElijahCreative": (
            subPath: "ElijahCreative_M_Resources/main/Wallpapers/",
            jsonFile: "ElijahCreative_M_Resources/main/JSON/elijahCreative.json"
        ),
        "timetravelr2025": (
            subPath: "TimeTraveler_M_Resources/main/Wallpapers/",
            jsonFile: "TimeTraveler_M_Resources/main/JSON/timetravelr2025.json"
        ),
        "patricialeveq": (
            subPath: "patricialeveq_M_Resources/main/Wallpapers/",
            jsonFile: "patricialeveq_M_Resources/main/JSON/patricialeveq.json"
        )
    ]
    
    func loadImages() {
        guard let urls = creatorURLs[creatorName],
              let url = URL(string: commonBaseUrl + urls.jsonFile) else {
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
                DispatchQueue.global().async {
                    let newImages = imageNames.filter { imageName in
                        !self.seenImages.contains(imageName)
                    }
                    
                    DispatchQueue.main.async {
                        self.newImagesCount = newImages.count
                        
                        self.images = imageNames.map { imageName in
                            let imageUrlString = self.commonBaseUrl + urls.subPath + imageName
                            var image = ImageModel(image: imageUrlString)
                            
                            let isNew = !self.seenImages.contains(image.baseName)
                            
                            if isNew {
                                self.seenImages.append(image.baseName)
                            }
                            
                            image.isNew = isNew
                            
                            return image
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
