//
//  ContentView.swift
//  LoadUrlData
//
//  Created by Sean Kelly on 16/05/2023.
//


import SwiftUI
import SDWebImageSwiftUI

struct LoadJSONView: View {
    @ObservedObject var viewModelHeader: DataViewModelHeader
    @Binding var selectedURLOverlayImage: ImageModelOverlayImage?
    @Binding var showOverlaysURLView: Bool
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModelHeader.images.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 30) {
                            ForEach(viewModelHeader.images) { image in
                                Button {
                                    selectedURLOverlayImage = image // Select the current image
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
                viewModelHeader.loadImages()
            }
            .navigationTitle("Overlays")
        }
    }
}

struct URLOverlayImageView: View {
    let image: ImageModelOverlayImage
    let imageCornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            
            WebImage(url: URL(string: image.image))
                .resizable() // Make sure to call resizable() directly on WebImage
                .placeholder {
                    ProgressView()
                }
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .center)
                .cornerRadius(imageCornerRadius)
        }
        .overlay {
            VStack {
                Spacer()
                VStack{
                    HStack {
                        Text(image.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    HStack {
                        Text(image.subtitle)
                            .font(.footnote)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                }
                .foregroundStyle(Color.primary)
                .colorInvert()
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: imageCornerRadius, bottomTrailingRadius: imageCornerRadius, topTrailingRadius: 0))
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

class DataViewModelHeader: ObservableObject {
    @Published var images: [ImageModelOverlayImage] = []
    
    func loadImages() {
        let urlString = "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/mOverlayImages.json"
        
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



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadJSONView()
//    }
//}
