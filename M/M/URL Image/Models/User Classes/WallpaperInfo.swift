//
//  WallpaperInfo.swift
//  M
//
//  Created by Sean Kelly on 20/03/2024.
//
/*
import SwiftUI

struct CreatorInfo: Codable {
    let name: String
    let subPath: String
    let jsonFile: String
    let imageURL: String
    let socialURL: String
}

class CreatorGitHubLoader: ObservableObject {
    @Published var CreatorInfos = [CreatorInfo]()

    init() {
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
                let CreatorInfos = try decoder.decode([CreatorInfo].self, from: data)
                
                DispatchQueue.main.async {
                    // Update the @Published property on the main thread
                    self.CreatorInfos = CreatorInfos
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject var creatorLoader = CreatorGitHubLoader()

    var body: some View {
        List(creatorLoader.CreatorInfos, id: \.name) { CreatorInfo in
            VStack(alignment: .leading) {
                Text(CreatorInfo.name)
                Text(CreatorInfo.subPath)
                Text(CreatorInfo.jsonFile)
                Text(CreatorInfo.imageURL)
                Text(CreatorInfo.socialURL)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() }
}

*/
