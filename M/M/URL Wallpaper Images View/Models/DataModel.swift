//
//  DataModel.swift
//  M
//
//  Created by Sean Kelly on 07/12/2023.
//


import SwiftUI

struct ImageModel: Identifiable, Hashable, Encodable {
    let id = UUID()
    let image: String
    var baseName: String {
        let fileName = URL(string: image)?.deletingPathExtension().lastPathComponent ?? ""
        return fileName
    }
    var isNew: Bool = false
}

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
    
    let baseUrl = "https://raw.githubusercontent.com/SCOSeanKly/"
    let creatorLoader = CreatorGitHubLoader() // Initialize the CreatorGitHubLoader
    
    init() {
        // Fetch creators and load images when DataViewModel is initialized
        creatorLoader.fetchCreators()
        loadImages()
    }
    
    func clearImageArray() {
        images = []
    }
    
    func loadImages() {
        guard let creatorInfo = creatorLoader.creatorInfos.first(where: { $0.name == creatorName }) else {
            return
        }
        
        let url = URL(string: baseUrl + creatorInfo.jsonFile)!
        
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
                            let imageUrlString = self.baseUrl + creatorInfo.subPath + imageName
                            var image = ImageModel(image: imageUrlString)
                            
                            let isNew = !self.seenImages.contains(image.baseName)
                            
                            if isNew {
                                self.seenImages.append(image.baseName)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                                    // Reset isNew to false after 60 seconds
                                    if let index = self.images.firstIndex(where: { $0.id == image.id }) {
                                        self.images[index].isNew = false
                                    }
                                }
                            }
                            
                            image.isNew = isNew
                            
                            return image
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func resetSeenImages() {
        seenImages = []
    }
}
