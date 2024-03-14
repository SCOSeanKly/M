//
//  NewImagesModel.swift
//  M
//
//  Created by Sean Kelly on 08/03/2024.
//

import SwiftUI

class NewImagesViewModel: ObservableObject {
    @Published var creators: [CreatorModel] = []
    
    init() {
        loadCreators()
    }
    
    func reloadData() {
        creators.removeAll() // Clear existing data
        loadCreators() // Load fresh data
    }
    
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
        "SmartWallpaperArt": (
            subPath: "SmartWallpaperArt_M_Resources/main/Wallpapers/",
            jsonFile: "SmartWallpaperArt_M_Resources/main/JSON/SmartWallpaperArt.json"
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
    
    private func loadCreators() {
        for (creatorName, urls) in creatorURLs {
            guard let url = URL(string: commonBaseUrl + urls.jsonFile) else {
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
                        var creatorModel = CreatorModel(name: creatorName, totalImagesCount: imageNames.count, imageURL: url)
                        creatorModel.loadNewImages(imageNames: imageNames)
                        self.creators.append(creatorModel)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}


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

