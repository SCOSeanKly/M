//
//  ImageMetadataViewModel.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

class ImageMetadataViewModel: ObservableObject {
    @Published var imageMetadata: [CFString: Any]? = nil
    @Published var isLoading: Bool = false // New loading state
    
    func fetchImageMetadata(from url: URL) {
        isLoading = true // Set loading state to true before making the request
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch image metadata: \(error?.localizedDescription ?? "")")
                DispatchQueue.main.async {
                    self.isLoading = false // Set loading state to false in case of an error
                }
                return
            }
            
            if let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
               let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
                
                if let tiffMetadata = properties[kCGImagePropertyTIFFDictionary] as? [CFString: Any] {
                    if let imageDescription = tiffMetadata[kCGImagePropertyTIFFImageDescription] {
                        
                        DispatchQueue.main.async {
                            self.imageMetadata = [kCGImagePropertyTIFFImageDescription: imageDescription]
                            self.isLoading = false // Set loading state to false on successful response
                            print("Image Metadata - ImageDescription: \(imageDescription)")
                        }
                    } else {
                        print("ImageDescription key not found in TIFF metadata")
                        DispatchQueue.main.async {
                            self.isLoading = false // Set loading state to false in case of an error
                        }
                    }
                } else {
                    print("TIFF metadata not found")
                    DispatchQueue.main.async {
                        self.isLoading = false // Set loading state to false in case of an error
                    }
                }
            } else {
                print("Failed to fetch image metadata")
                DispatchQueue.main.async {
                    self.isLoading = false // Set loading state to false in case of an error
                }
            }
        }.resume()
    }
}

