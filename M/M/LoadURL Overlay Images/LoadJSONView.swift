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
    @Binding var selectedURLOverlayImage: ImageModelOverlayImage?
    @Binding var showOverlaysURLView: Bool
    @AppStorage("selectedOverlayType") private var selectedOverlayType: String = "Complete"
    
    // Define overlayURLs within LoadJSONView
    private let overlayURLs: [String: String] = [
        "Overlay": "mOverlayImages.json",
        "Dock": "mDockImages.json",
        "Notch": "mNotchImages.json",
        "Complete": "mCompleteImages.json",
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Overlay Type", selection: $selectedOverlayType) {
                    ForEach(overlayURLs.keys.sorted(), id: \.self) { key in
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
                                    selectedURLOverlayImage = image
                                    showOverlaysURLView.toggle()
                                } label: {
                                    URLOverlayImageView(image: image)
                                        .cornerRadius(5)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                 
                    
                } else {
                    Text("Loading images...")
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
    let image: ImageModelOverlayImage
    let imageCornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            
            Image("p_SKE2060")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2.5,  alignment: .center)
               
            WebImage(url: URL(string: image.image))
                .resizable()
            
                .placeholder {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2.5,  alignment: .center)
               
        }
      
     
        .clipShape(RoundedRectangle(cornerRadius: imageCornerRadius))
        .overlay {
            VStack {
                Spacer()
                VStack{
                    HStack {
                        Text(image.title)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .blendMode(.difference)
                            .overlay{
                                Text(image.title)
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .blendMode(.hue)
                            }
                            .overlay{
                                Text(image.title)
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .blendMode(.overlay)
                            }
                            .overlay{
                                Text(image.title)
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                    .blendMode(.overlay)
                            }
                           
                        Spacer()
                    }
                    HStack {
                        Text(image.subtitle)
                            .font(.system(size: 8, weight: .regular, design: .rounded))
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .blendMode(.difference)
                            .overlay{
                                Text(image.subtitle)
                                    .font(.system(size: 8, weight: .regular, design: .rounded))
                                    .lineLimit(1)
                                    .blendMode(.hue)
                            }
                            .overlay{
                                Text(image.subtitle)
                                    .font(.system(size: 8, weight: .regular, design: .rounded))
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .blendMode(.overlay)
                            }
                            .overlay{
                                Text(image.subtitle)
                                    .font(.system(size: 8, weight: .regular, design: .rounded))
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                                    .blendMode(.overlay)
                            }
                        
                        Spacer()
                    }
                }
                .padding()
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
    
    private let overlayURLs: [String: String] = [
        "Overlay": "mOverlayImages.json",
        "Dock": "mDockImages.json",
        "Notch": "mNotchImages.json",
        "Complete": "mCompleteImages.json",
        
    ]
    
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

struct FullSizeImageView: View {
    let image: ImageModelOverlayImage
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        AsyncImage(url: URL(string: image.image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let loadedImage):
                loadedImage
                    .resizable()
                    .frame(width: screenWidth, height: screenHeight)
                    .clipShape(Rectangle())
            case .failure:
                Image(systemName: "xmark.circle")
            @unknown default:
                EmptyView()
            }
        }
        
        
        
    }
}
