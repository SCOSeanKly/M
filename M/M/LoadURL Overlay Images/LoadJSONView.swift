//
//  ContentView.swift
//  LoadUrlData
//
//  Created by Sean Kelly on 16/05/2023.
//


import SwiftUI
import SDWebImageSwiftUI


struct LoadJSONView: View {
    @ObservedObject var viewModelHeader: DataViewModelOverlays
    @Binding var selectedURLOverlayImages: [ImageModelOverlayImage]  // Change to array
    @Binding var showOverlaysURLView: Bool
    @AppStorage("selectedOverlayType") private var selectedOverlayType: String = "Complete"
    @StateObject var obj: Object
    
    // Define overlayURLs within LoadJSONView
    private let overlayURLs: [String] = [
        "Overlay",
        "Dock",
        "Notch",
        "Complete",
        "Effects"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Overlay Type", selection: $selectedOverlayType) {
                    ForEach(overlayURLs.sorted(), id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedOverlayType) {
                    // When selectedOverlayType changes, load images for the new overlay type
                    viewModelHeader.overlayType = selectedOverlayType
                    viewModelHeader.loadImages()
                }
                
                if !viewModelHeader.images.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 30) {
                            ForEach(viewModelHeader.images) { image in
                                Button {
                                    selectedURLOverlayImages.append(image) // Append image instead of assigning
                                    showOverlaysURLView.toggle()
                                } label: {
                                    URLOverlayImageView(images: [image]) // Pass array of image
                                        .cornerRadius(5)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                } else {
                    LoadingImagesView(obj: obj)
                }
            }
            .onAppear {
                viewModelHeader.overlayType = selectedOverlayType
                viewModelHeader.loadImages()
            }
            .navigationTitle(selectedOverlayType)
        }
    }
}



struct URLOverlayImageView: View {
    let images: [ImageModelOverlayImage]
    let imageCornerRadius: CGFloat = 20
    let frameSize = CGSize(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2.5)
    
    var body: some View {
        ZStack {
            ForEach(images, id: \.id) { image in
                Image("p_SKE2060")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: imageCornerRadius))
                
                WebImage(url: URL(string: image.image))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: imageCornerRadius))
                    .overlay {
                        ImageTitleSubTitleView(image: image)
                    }
            }
        }
    }
}



struct ImageModelOverlayImage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
}


class DataViewModelOverlays: ObservableObject {
    @Published var images: [ImageModelOverlayImage] = []
    @Published var overlayType: String = "Complete"
    private let commonBaseUrl = "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/Overlays/"
    
    @Published var forceRefreshOverlays: Bool = false {
        didSet {
            if forceRefreshOverlays {
                loadImages()
            }
        }
    }
    
    private lazy var overlayURLs: [String: String] = {
        let deviceIdentifier = UIDevice.current.modelName
        let effectURL = "mEffect_\(deviceIdentifier.replacingOccurrences(of: "iPhone", with: "").replacingOccurrences(of: ",", with: "")).json"
        
        return [
            "Overlay": "mOverlayImages.json",
            "Dock": "mDockImages.json",
            "Notch": "mNotchImages.json",
            "Complete": "mCompleteImages.json",
            "Effect": effectURL
        ]
    }()
    
    func loadImages() {
        guard let jsonFileName = overlayURLs[overlayType],
              let url = URL(string: commonBaseUrl + jsonFileName) else {
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
                let imageData = try JSONDecoder().decode([ImageData].self, from: data)
                DispatchQueue.main.async {
                    self.images = imageData.map { imageData in
                        ImageModelOverlayImage(
                            image: imageData.image,
                            title: imageData.title,
                            subtitle: imageData.subtitle
                        )
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}


struct ImageData: Decodable {
    let image: String
    let title: String
    let subtitle: String
}

struct OverlaysImageView: View {
    let image: ImageModelOverlayImage
    let frameSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    var body: some View {
        
        AsyncImage(url: URL(string: image.image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let loadedImage):
                loadedImage
                    .resizable()
                    .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
                    .clipShape(Rectangle())
            case .failure:
                Image(systemName: "xmark.circle")
            @unknown default:
                EmptyView()
            }
        }
    }
}



