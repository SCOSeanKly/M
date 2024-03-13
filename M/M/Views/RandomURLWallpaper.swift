//
//  RandomImage.swift
//  M
//
//  Created by Sean Kelly on 13/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct RandomURLWallpaper: View {
    @StateObject var imageURLStore: ImageURLStore

    var body: some View {
        ZStack {
            if let imageURL = imageURLStore.imageURL {
                WebImage(url: imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                Text(imageURL.lastPathComponent
                    .replacingOccurrences(of: ".jpg", with: "")
                    .replacingOccurrences(of: "p_", with: ""))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 5)
                    .multilineTextAlignment(.center)
                    .offset(y: UIScreen.main.bounds.height * 0.3)
                
            } else {
               ProgressView()
            }
        }
        .onAppear {
            loadRandomImage()
        }
    }

    func loadRandomImage() {
        guard let jsonURL = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/wallpaperImages.json") else {
            return
        }

        URLSession.shared.dataTask(with: jsonURL) { data, response, error in
            guard let data = data else {
                return
            }

            do {
                let imageNames = try JSONDecoder().decode([String].self, from: data)
                let randomImageName = imageNames.randomElement() ?? ""
                let imageURL = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/Wallpapers/\(randomImageName)")

                DispatchQueue.main.async {
                    self.imageURLStore.imageURL = imageURL
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

class ImageURLStore: ObservableObject {
    @Published var imageURL: URL?

    init() {} // Add this initializer
}

struct RandomURLWallpaper_Previews: PreviewProvider {
    static var previews: some View {
        let imageURLStore = ImageURLStore() // Create an instance of ImageURLStore
        return RandomURLWallpaper(imageURLStore: imageURLStore) // Pass it to RandomURLWallpaper
    }
}
