//
//  MDataModel.swift
//  M
//
//  Created by Sean Kelly on 09/03/2024.
//

import SwiftUI

class CombinedViewModel: ObservableObject {
    // Data for Updates
    @Published var updates: [Update] = []
    @Published var showNewDataAlert: Bool = false
    private var previousData: Data?
    private var lastCheckedTime: Date?
    
    // Data for NewImages
    @Published var creators: [CreatorModel] = []
    
    // Data for Images
    @Published var images: [ImageModel] = []
    @Published var forceRefresh: Bool = false
    @Published var creatorName: String = "SeanKly"
    @AppStorage("seenImages") var seenImages: [String] = []
    @Published var newImagesCount: Int = 0
    
    // Common Base URL
    private let commonBaseUrl = "https://raw.githubusercontent.com/SCOSeanKly/"
    
    // URLs for different creators
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
    
    // Function to fetch updates
    func fetchData() {
        // Fetch Updates
        guard let url = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/Update/update.json") else {
            print("Invalid URL")
            return
        }
        
        let currentTime = Date()
        
        // Check if last checked time is greater than 4 hours from the current time
        if let lastCheckedTime = self.lastCheckedTime,
           let timeInterval = Calendar.current.dateComponents([.hour], from: lastCheckedTime, to: currentTime).hour,
           timeInterval < 1 {
            print("Last checked less than 1 hour ago, skipping data fetch.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let previousData = self.previousData, data != previousData {
                        print("JSON data changed, show alert")
                        self.showNewDataAlert = true
                    } else {
                        print("No new JSON data changes found")
                    }
                    
                    self.previousData = data
                    
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let updates = try decoder.decode([Update].self, from: data)
                    DispatchQueue.main.async {
                        self.updates = updates
                        // Print the fetched JSON data
                        print(updates)
                    }
                    
                    // Update the last checked time
                    self.lastCheckedTime = currentTime
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        // Fetch Creators and Images
        loadCreatorsAndImages()
    }
    
    // Function to load creators and images
    private func loadCreatorsAndImages() {
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
                        
                        let newImages = imageNames.filter { imageName in
                            !self.seenImages.contains(imageName)
                        }
                        self.newImagesCount += newImages.count
                        
                        let creatorUrls = self.creatorURLs[creatorName]
                        if let subPath = creatorUrls?.subPath {
                            self.images += imageNames.map { imageName in
                                let imageUrlString = self.commonBaseUrl + subPath + imageName
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
}
