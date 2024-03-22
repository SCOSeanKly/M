//
//  DataModel.swift
//  M
//
//  Created by Sean Kelly on 07/12/2023.
//


import SwiftUI

class DataViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
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
    
    private var urlSession: URLSession!
    private var creatorInfo: CreatorInfo? // Store creatorInfo as a property
    
    override init() {
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        // Fetch creators and load images when DataViewModel is initialized
        creatorLoader.fetchCreators()
        loadImages()
    }
    
    func clearImageArray() {
        images = []
    }
    
    func resetSeenImages() {
        seenImages = []
    }
    
    func loadImages() {
        
        
        guard let creatorInfo = creatorLoader.creatorInfos.first(where: { $0.name == creatorName }) else {
            return
        }
        
        self.creatorInfo = creatorInfo // Store creatorInfo
        
        let url = URL(string: baseUrl + creatorInfo.jsonFile)!
        
        let task = urlSession.downloadTask(with: url)
        task.resume()
    }
    
   
    // MARK: - URLSessionDownloadDelegate Methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let creatorInfo = self.creatorInfo else {
            return
        }
        
        guard let data = try? Data(contentsOf: location),
              let imageNames = try? JSONDecoder().decode([String].self, from: data) else {
            return
        }
        
        let newImages = imageNames.filter { imageName in
            !seenImages.contains(imageName)
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
}


