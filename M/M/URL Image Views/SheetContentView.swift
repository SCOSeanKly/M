//
//  SheetContentView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

struct SheetContentView: View {
    @StateObject var viewModel: DataViewModel
    let image: ImageModel
    @StateObject var viewModelContent: ContentViewModel
    @Binding var saveState: URLImages.SaveState
    @StateObject var obj: Object
    @State private var isTapped: Bool = false
    let saveTip = SaveWallpaperTip()
    @Binding var isZooming: Bool
    @Binding var showPremiumContent: Bool
    let error: String = "ERROR - FILE DOES NOT EXIST"
    @State private var isNoAIPromptVisible: Bool = false
    @State private var isNoAIPromptVisibleAnimation: Bool = false
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init()
    
    
    var body: some View {
        
      
            
            LargeImageView(image: image, viewModelContent: viewModelContent, obj: obj, isNoAIPromptVisible: $isNoAIPromptVisible, isNoAIPromptVisibleAnimation: $isNoAIPromptVisibleAnimation)
            .overlay{
                VStack {
                    
                    Spacer()
                    Button {
                        isTapped.toggle()
                        saveImage()
                    } label: {
                        switch saveState {
                        case .idle:
                            SaveStateIdle()
                        case .saving:
                            SaveStateSaving()
                        case .saved:
                            SaveStateSaved()
                        }
                    }
                    .padding(8)
                    .background(Color.primary.colorInvert())
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .animation(.bouncy, value: saveState)
                    .sensoryFeedback(.selection, trigger: isTapped)
                }
                .frame(height: UIScreen.main.bounds.height * 0.8)
            }
          
        
    }
    
    private func saveImage() {
        saveState = .saving
        
        guard var urlComponents = URLComponents(string: image.image) else {
            saveState = .idle
            return
        }
        
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
                } else {
                    modifiedImageName = imageName
                }
                
                pathComponents[pathComponents.count - 1] = modifiedImageName
                urlComponents.path = pathComponents.joined(separator: "/")
                
                guard let modifiedURL = urlComponents.url else {
                    saveState = .idle
                    return
                }
                
                URLSession.shared.dataTask(with: modifiedURL) { data, response, error in
                    if let data = data, let originalUIImage = UIImage(data: data) {
                        // Save the original image as PNG
                        if let pngData = originalUIImage.pngData() {
                            UIImage(data: pngData)?.writeToPhotosAlbum()
                            provideSuccessFeedback()
                            saveState = .saved
                            viewModel.loadImages()
                        } else {
                            saveState = .idle
                        }
                    } else {
                        saveState = .idle
                    }
                }.resume()
            }
        }
    }
    
}
