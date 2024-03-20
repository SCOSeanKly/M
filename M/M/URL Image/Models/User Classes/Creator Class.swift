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

import SwiftUI

struct CreatorURLButtons: View {
    @StateObject var creatorLoader = CreatorGitHubLoader()
    @Environment(\.openURL) var openURL
    @State private var isButtonTapped: Bool = false
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(creatorLoader.creatorInfos, id: \.self) { creatorInfo in

                    if let imageURL = URL(string: creatorInfo.imageURL) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                Button {
                                    if let socialURL = URL(string: creatorInfo.socialURL) {
                                        openURL(socialURL)
                                    }
                                    isButtonTapped.toggle()
                                } label: {
                                    VStack {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .padding(.top)
                                            
                                        // Assuming you have different icons for different social media platforms
                                        Image(creatorInfo.name == "widgy" ? "reddit" : "twitter")
                                                                       .resizable()
                                                                       .aspectRatio(contentMode: .fill)
                                                                       .frame(width: 20, height: 20)
                                                                       .clipShape(Circle())
                                                                       .offset(x: 10.0, y: -20)
                                            
                                        Text(creatorInfo.name)
                                            .font(.system(size: 8, weight: .regular, design: .rounded))
                                            .offset(y: -15)
                                    }
                                }

                                .frame(width: 78, height: 90)
                                .buttonStyle(.plain)
                            case .failure(let error):
                                // Handle failure
                                CreatorPlaceholder()
                            case .empty:
                                // Placeholder or loading indicator if needed
                                CreatorPlaceholder()
                            @unknown default:
                                // Handle unknown state
                                CreatorPlaceholder()
                            }
                        }
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: isButtonTapped)
        }
        .onAppear {
            // Fetch data when view appears
            creatorLoader.fetchCreators()
        }

    }
}

#if DEBUG
struct CreatorURLButtons_Previews: PreviewProvider {
    static var previews: some View {
        CreatorURLButtons()
    }
}
#endif
