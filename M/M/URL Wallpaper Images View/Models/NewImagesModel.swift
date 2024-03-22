//
//  NewImagesModel.swift
//  M
//
//  Created by Sean Kelly on 08/03/2024.
//

import SwiftUI
import Foundation

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
    private var creatorLoader = CreatorGitHubLoader()

    private func loadCreators() {
        creatorLoader.fetchCreators()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Wait for fetching creators
            for creatorInfo in self.creatorLoader.creatorInfos {
                let url = URL(string: self.commonBaseUrl + creatorInfo.jsonFile)!
                
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
                            var creatorModel = CreatorModel(name: creatorInfo.name, totalImagesCount: imageNames.count, imageURL: URL(string: creatorInfo.imageURL)!)
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
}


