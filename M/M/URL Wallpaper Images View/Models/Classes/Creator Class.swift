//
//  TwitterUser.swift
//  M
//
//  Created by Sean Kelly on 19/03/2024.
//


import SwiftUI
import Foundation

struct CreatorInfo: Codable, Hashable {
    let name: String
    let subPath: String
    let jsonFile: String
    let imageURL: String
    let socialURL: String
}


class CreatorGitHubLoader: ObservableObject {
    @Published var creatorInfos = [CreatorInfo]()

    init() {
        // Initialization code if any
    }

    func fetchCreators() {
        // Assuming you have a URL where your JSON data is hosted
        let url = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/creatorURLs.json")!
    

        // Create a URLSession
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching JSON: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned from JSON fetch")
                return
            }

            do {
                // Decode JSON data into an array of CreatorInfo objects
                let decoder = JSONDecoder()
                let creatorInfos = try decoder.decode([CreatorInfo].self, from: data)
                
                DispatchQueue.main.async {
                    // Update the @Published property on the main thread
                    self.creatorInfos = creatorInfos
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

