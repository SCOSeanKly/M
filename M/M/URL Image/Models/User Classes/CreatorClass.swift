//
//  CreatorClass.swift
//  M
//
//  Created by Sean Kelly on 20/03/2024.
//

/*
import SwiftUI

class CreatorClass: ObservableObject {
    @Published var cachedImages: [String: UIImage] = [:]
    @Published var userURLs: [String: URL] = [:]
    @Published var socialMediaURLs: [String: URL] = [:]
    
    init() {
        for (username, data) in WallpaperURLData.creatorURLs {
            userURLs[username] = data.imageURL
            socialMediaURLs[username] = data.socialURL
        }
    }
    
    func getCachedImages() -> [String: UIImage] {
        return cachedImages
    }
    
    func fetchImages(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for (username, url) in userURLs {
            dispatchGroup.enter()
            
            // Check if the image is already cached
            if cachedImages[username] != nil {
                dispatchGroup.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                
                guard let data = data, error == nil else {
                    print("Failed to fetch image for \(username):", error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                if let image = UIImage(data: data) {
                    // Cache the image
                    DispatchQueue.main.async {
                        self.cachedImages[username] = image
                    }
                }
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func refreshCache(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.fetchImages(completion: completion)
        }
    }
}
*/
