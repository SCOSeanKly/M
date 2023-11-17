//
//  URLImage.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI

struct URLImages: View {
    @ObservedObject var viewModel = DataViewModel()
    @State private var selectedImage: ImageModel?
    @State private var isSheetPresented = false
    @State private var saveState: SaveState = .idle

    enum SaveState {
        case idle
        case saving
        case saved
    }

    var body: some View {
        ZStack {
            VStack {
                if !viewModel.images.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                Button {
                                    selectedImage = viewModel.images[index]
                                    isSheetPresented = true
                                    saveState = .idle
                                } label: {
                                    URLImageView(image: viewModel.images[index])
                                        .customFrame()
                                }
                            }
                        }
                        .padding(10)
                    }
                } else {
                    Text("Loading images...")
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let image = selectedImage {
                SheetContentView(image: image, isSheetPresented: $isSheetPresented, saveState: $saveState)
                    .onChange(of: saveState) { newState in
                        // Close the sheet when the state transitions to .saved
                        if newState == .saved {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isSheetPresented = false
                            }
                        }
                    }
            }
        }
        .onAppear {
            viewModel.loadImages()
        }
        .onReceive(viewModel.$forceRefresh) { refresh in
            if refresh {
                viewModel.loadImages()
            }
        }
    }
}

struct SheetContentView: View {
    let image: ImageModel
    @Binding var isSheetPresented: Bool
    @Binding var saveState: URLImages.SaveState

    var body: some View {
        VStack {
            LargeImageView(image: image)

            Button {
                saveImage()
            } label: {
                switch saveState {
                case .idle:
                    Text("Save Image")
                case .saving:
                    Text("Saving...")
                case .saved:
                    Text("Saved")
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
    }

    private func saveImage() {
        saveState = .saving

        guard var urlComponents = URLComponents(string: image.image) else {
            saveState = .idle
            return
        }

        // Assuming the image name is part of the path, e.g., "images/123.png"
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                // Check the file extension and append "_fullRes" accordingly
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".png") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".png", with: "_fullRes.png", options: .caseInsensitive)
                } else if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.jpg", options: .caseInsensitive)
                } else {
                    // If the file extension is not ".png" or ".jpg", skip modification
                    modifiedImageName = imageName
                }

                pathComponents[pathComponents.count - 1] = modifiedImageName
                urlComponents.path = pathComponents.joined(separator: "/")

                // Set the modified URL
                guard let modifiedURL = urlComponents.url else {
                    saveState = .idle
                    return
                }

                // Use URLSession for asynchronous loading
                URLSession.shared.dataTask(with: modifiedURL) { data, response, error in
                    if let data = data, let uiImage = UIImage(data: data) {
                        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                        saveState = .saved
                    } else {
                        // Fallback to the original image if the modified image loading fails
                        URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
                            if let data = data, let uiImage = UIImage(data: data) {
                                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                saveState = .saved
                            }
                        }.resume()
                    }
                }.resume()
            }
        }
    }
}


struct LargeImageView: View {
    let image: ImageModel
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: image.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 550)
                        .cornerRadius(15)
                        .clipped()
                case .failure:
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.system(size: 60))
                @unknown default:
                    EmptyView()
                }
            }
            .padding()
            .padding(.top, 50)
            
            Spacer()
        }
        .customPresentationWithPrimaryBackground(detent: .large, backgroundColorOpacity: 1.0)
    }
}

struct URLImageView: View {
    let image: ImageModel
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: image.image)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .customFrame()
                        ProgressView()
                    }
                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .customFrame()
                        Image(systemName: "xmark.circle")
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .customFrame()
        }
    }
}

struct ImageModel: Identifiable {
    let id = UUID()
    let image: String
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
    
    func loadImages() {
        let baseUrlString = "https://raw.githubusercontent.com/SCOSeanKly/kerrandsmith/main/scrollingHeaderImages/headerImages/"
        let urlString = "https://raw.githubusercontent.com/SCOSeanKly/kerrandsmith/main/scrollingHeaderImages/scrollingHeaderImages.json"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
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
                    self.images = imageNames.indices.map { index in
                        let imageName = imageNames[index]
                        let imageUrlString = baseUrlString + imageName
                        let image = ImageModel(image: imageUrlString)
                        return image
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension View {
    func customFrame(width: CGFloat = UIScreen.main.bounds.width / 4 , height: CGFloat = UIScreen.main.bounds.height / 4) -> some View {
        self
            .frame(width: width, height: height)
            .scaledToFill()
            .cornerRadius(15)
            .clipped()
    }
}


struct URLImages_Previews: PreviewProvider {
    static var previews: some View {
        URLImages()
    }
}


