//
//  URLUnused.swift
//  M
//
//  Created by Sean Kelly on 22/11/2023.
//

/*
struct LargeImageView: View {
    let image: ImageModel
    let frameSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: image.image)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.clear
                            .frame(width: frameSize.width, height: frameSize.height)
                        
                        ProgressView()
                    }
                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: frameSize.width, height: frameSize.height)
                        .cornerRadius(40)
                        .clipped()
                       
                case .failure:
                    ZStack {
                        
                        Color.clear
                            .frame(width: frameSize.width, height: frameSize.height)
                        
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                            .font(.system(size: 60))
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.top, 50)
            
            Spacer()
        }
        .customPresentationWithPrimaryBackground(detent: .large, backgroundColorOpacity: 1.0)
    }
}
 */

/*
struct URLImageView: View {
    let image: ImageModel
    @State private var imageSize: String = "Fetching size..."
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image.image)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(.clear)
                          
                        ProgressView()
                    }
                case .success(let loadedImage):
                    
                    loadedImage
                        .resizable()
                      
                case .failure:
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(.clear)
                          
                        Image(systemName: "xmark.circle")
                        
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .customFrame()
        }
    }
    
    private func fetchImageSize() {
        guard let imageUrl = URL(string: image.image) else {
            return
        }
        
        let request = URLRequest(url: imageUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                let contentLength = response.allHeaderFields["Content-Length"] as? String
                if let contentLength = contentLength, let size = Int(contentLength) {
                    let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                    DispatchQueue.main.async {
                        imageSize = "Size: \(formattedSize)"
                    }
                }
            }
        }.resume()
    }
}
 */
