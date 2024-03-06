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
    @State private var showSheetBackground: Bool = true
    
    // Define overlayURLs within LoadJSONView
    private let overlayURLs: [String] = [
        "Pattern",
        "Dock",
        "Notch",
        "Complete",
        "Effect"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Text(selectedOverlayType)
                        .font(.largeTitle.bold())
                      
                    if selectedOverlayType == "Effect" {
                    
                    Text(UIDevice.current.modelName)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                      
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                Picker("Select Overlay Type", selection: $selectedOverlayType) {
                    ForEach(overlayURLs.sorted(), id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.bottom, .horizontal])
                .onChange(of: selectedOverlayType) {
                    // When selectedOverlayType changes, load images for the new overlay type
                    viewModelHeader.overlayType = selectedOverlayType
                    viewModelHeader.loadImages()
                    viewModelHeader.images = [] //MARK: Clears array
                }
                
                if viewModelHeader.images.isEmpty {
                  
                     //MARK: ADD ERROR?
                         
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 30) {
                           // ForEach(viewModelHeader.images.sorted(by: { $0.title < $1.title })) { image in
                            ForEach(viewModelHeader.images.reversed()) { image in
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
                }
                
                Spacer()
                 
            }
            .modifier(PresentationModifiers(showSheetBackground: $showSheetBackground))
            .onAppear {
                viewModelHeader.overlayType = selectedOverlayType
                viewModelHeader.loadImages()
            }
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
                       ProgressViewBlend()
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
    
    @AppStorage("seenOverlayImages") var seenOverlayImages: [String] = []
    
    private lazy var overlayURLs: [String: String] = {
        let deviceIdentifier = UIDevice.current.modelName
      //  let deviceIdentifier = "iPhone15,3"
        
        let effectURL = "mEffect_\(deviceIdentifier.replacingOccurrences(of: "iPhone", with: "").replacingOccurrences(of: ",", with: "")).json"
        
        return [
            "Pattern": "mOverlayImages.json",
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

struct ProgressViewBlend: View {
    var body: some View {
        ProgressView()
            .foregroundColor(.white)
            .blendMode(.difference)
            .overlay{
                ProgressView()
                    .blendMode(.hue)
            }
            .overlay{
                ProgressView()
                    .foregroundColor(.white)
                    .blendMode(.overlay)
            }
            .overlay{
                ProgressView()
                    .foregroundColor(.black)
                    .blendMode(.overlay)
            }
    }
}

