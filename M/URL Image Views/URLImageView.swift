//
//  URLImageView.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct URLImages: View {
    @ObservedObject var viewModel = DataViewModel()
    @State private var selectedImage: ImageModel?
    @State private var isSheetPresented = false
    @State private var saveState: SaveState = .idle
    @StateObject var obj: Object
    
    enum SaveState {
        case idle
        case saving
        case saved
    }
    
    var totalFilesCount: Int {
        return viewModel.images.count
    }
    @State private var showCount: Bool = false
    
    @State private var scrollID: Int?
    @State private var scrollPosition: CGFloat = 0.0
    @State private var isTapped: Bool = false
    
    @State var scrollerHeight: CGFloat = 0
    @State var indicatorOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @State var hideIndicatorLabel: Bool = true
    @State var timeOut: CGFloat = 0.3
    
    
    var body: some View {
        ZStack {
            VStack {
                
                ButtonView(obj: obj, viewModel: viewModel)
                
                if !viewModel.images.isEmpty {
                    
                    GeometryReader{
                        let size = $0.size
                        
                        ScrollViewReader(content: { proxy in
                            ScrollView(.vertical, showsIndicators: true) {
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 30) {
                                    
                                    ForEach(viewModel.images.indices.reversed(), id: \.self) { index in
                                        Button {
                                            isTapped.toggle()
                                            selectedImage = viewModel.images[index]
                                            isSheetPresented = true
                                            saveState = .idle
                                        } label: {
                                            WebImage(url: URL(string: viewModel.images[index].image))
                                                .resizable()
                                                .customFrame()
                                        }
                                    }
                                }
                                .padding(10)
                                .scrollTargetLayout()
                                
                                .offset { rect in
                                    
                                    if hideIndicatorLabel && rect.minY < 0{
                                        timeOut = 0
                                        hideIndicatorLabel = false
                                    }
                                    
                                    let rectHeight = rect.height
                                    let viewHeight = size.height + (startOffset / 2)
                                    let scrollerHeight = (viewHeight / rectHeight) * viewHeight
                                    self.scrollerHeight = scrollerHeight
                                    let progress = rect.minY / (rectHeight - size.height)
                                    self.indicatorOffset = -progress * (size.height * 0.88 - scrollerHeight)
                                }
                                
                                Spacer()
                                    .frame(height: 100)
                            }
                        })
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .overlay(alignment: .topTrailing, content: {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 2, height: scrollerHeight)
                                .overlay(alignment: .trailing, content: {
                                    Text("\(scrollID ?? 0)")
                                        .font(.system(size: 12, design: .rounded).weight(.medium))
                                        .foregroundColor(.primary)
                                        .frame(width: 40, height: 20)
                                        .padding(3)
                                        .background(Color.primary.colorInvert())
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: hideIndicatorLabel ? 65 : -13)
                                        .animation(.bouncy, value: hideIndicatorLabel)
                                })
                                .padding(.trailing,5)
                                .offset(y: indicatorOffset + 40)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        })
                    }
                    .offset { rect in
                        if startOffset != rect.minY{
                            startOffset = rect.minY
                        }
                    }
                    .scrollPosition(id: $scrollID)
                    .onChange(of: scrollID) { oldValue, newValue in
                        print(newValue ?? "")
                    }
                } else {
                    LoadingImagesView()
                }
                
                Spacer()
            }
            .onReceive(Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()) { _ in
                if timeOut < 0.3{
                    timeOut += 0.01
                }else{
                    // MARK: Scrolling is Finished
                    if !hideIndicatorLabel{
                        print("Scrolling is Finished")
                        hideIndicatorLabel = true
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(item: $selectedImage) { image in
            SheetContentView(image: image, saveState: $saveState, obj: obj)
                .id(image) // Ensure image is used for id
                .onDisappear {
                    selectedImage = nil
                }
                .onChange(of: saveState) {
                    if saveState == .saved {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            selectedImage = nil
                            saveState = .idle // Reset saveState
                        }
                    }
                }
        }
        .onChange(of: selectedImage) {
            if selectedImage != nil {
                isSheetPresented = true
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

// MARK: Offset Reader
extension View{
    @ViewBuilder
    func offset(completion: @escaping (CGRect)->())->some View{
        self
            .overlay {
                GeometryReader{
                    let rect = $0.frame(in: .named("SCROLLER"))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct SheetContentView: View {
    let image: ImageModel
    @Binding var saveState: URLImages.SaveState
    @StateObject var obj: Object
    @State private var imageSize: String = "Fetching file size..."
    @State private var imageFileFormat: String = ""
    @State private var isTapped: Bool = false
    
    var body: some View {
        VStack {
            
            LargeImageView(image: image)
            
            HStack(alignment: .center){
                Text(imageSize)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.top, 4)
                
                if imageSize != "Fetching file size..." {
                    Text(imageFileFormat.dropFirst(2))
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .offset(y: 2)
                }
            }
            .offset(y: 50)
            
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
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .animation(.bouncy, value: saveState)
            .offset(y: -50)
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .onAppear {
            fetchImageSize()
        }
    }
    
    private func fetchImageSize() {
        guard var urlComponents = URLComponents(string: image.image) else {
            return
        }
        
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                _ = (imageName as NSString).pathExtension
                
                var modifiedImageName: String
                if imageName.lowercased().hasSuffix(".png") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".png", with: "_fullRes.PNG", options: .caseInsensitive)
                } else if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
                } else {
                    modifiedImageName = imageName
                }
                
                let modifiedExtension = (modifiedImageName as NSString).pathExtension
                pathComponents[pathComponents.count - 1] = modifiedImageName
                urlComponents.path = pathComponents.joined(separator: "/")
                
                guard let modifiedURL = urlComponents.url else {
                    return
                }
                
                var request = URLRequest(url: modifiedURL)
                request.httpMethod = "HEAD"
                
                URLSession.shared.dataTask(with: request) { _, response, _ in
                    if let httpResponse = response as? HTTPURLResponse {
                        if let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String,
                           let size = Int(contentLength) {
                            let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                            let fileFormat = modifiedExtension.isEmpty ? "" : ".\(modifiedExtension)"
                            DispatchQueue.main.async {
                                imageSize = "Size: \(formattedSize)"
                                imageFileFormat = " \(fileFormat)"
                            }
                        }
                    }
                }.resume()
            }
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
                // Check the file extension and append "_fullRes" accordingly
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".png") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".png", with: "_fullRes.png", options: .caseInsensitive)
                } else if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
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
                        provideSuccessFeedback()
                        saveState = .saved
                    } else {
                        // Fallback to the original image if the modified image loading fails
                        URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
                            if let data = data, let uiImage = UIImage(data: data) {
                                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                provideSuccessFeedback()
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
    let frameSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: image.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: frameSize.width, height: frameSize.height)
                .cornerRadius(40)
                .clipped()
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
            WebImage(url: URL(string: image.image))
                .resizable()
                .customFrame()
        }
    }
}

struct ImageModel: Identifiable, Hashable {
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
        
        let baseUrlString = "https://raw.githubusercontent.com/SCOSeanKly/M/main/M/Wallpapers/"
        let urlString = "https://raw.githubusercontent.com/SCOSeanKly/M/main/M/JSON/wallpaperImages.json"
        
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
            .aspectRatio(contentMode: .fill)
            .cornerRadius(15)
            .clipped()
            .scrollTransition(.animated.threshold(.visible(0.1))) { content, phase in
                           content
                             //.opacity(phase.isIdentity ? 1 : 0)
                               .scaleEffect(phase.isIdentity ? 1 : 0.75)
                             //.blur(radius: phase.isIdentity ? 0 : 10)
                       }
        
        
    }
}






