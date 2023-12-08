//
//  URLImageView.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import TipKit


struct URLImages: View {
    @ObservedObject var viewModel = DataViewModel()
    @StateObject var viewModelContent: ContentViewModel
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
    
    var colorScheme: ColorScheme? {
        switch obj.appearance.selectedAppearance {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    
    var body: some View {
        ZStack {
            VStack {
                
                ButtonView(obj: obj, viewModel: viewModel)
                
                if !viewModel.images.isEmpty {
                    
                    GeometryReader{
                        let size = $0.size
                        
                        ScrollViewReader(content: { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: Array(repeating: GridItem(), count: obj.appearance.showTwoWallpapers ? 2 : 3), spacing: 30) {
                                    
                                    ForEach(viewModel.images.indices.reversed(), id: \.self) { index in
                                        
                                        VStack {
                                            Button {
                                                isTapped.toggle()
                                                selectedImage = viewModel.images[index]
                                                isSheetPresented = true
                                                saveState = .idle
                                            } label: {
                                                WebImage(url: URL(string: viewModel.images[index].image))
                                                    .resizable()
                                                    .customFrameBasedOnCondition(obj: obj)
                                                    .overlay {
                                                        //MARK: Add a star if wallpaper is premium
                                                        if viewModel.images[index].image.contains("p_") {
                                                            StarView(text: "")
                                                        }
                                                        
                                                        if viewModel.images[index].isNew {
                                                            NewWallAddedView()
                                                                .customFrameBasedOnCondition(obj: obj)
                                                        }
                                                    }
                                            }
                                            
                                            Text(getFileName(from: viewModel.images[index].image)
                                                .replacingOccurrences(of: "p_", with: ""))
                                            .font(.system(size: 10))
                                            .foregroundColor(.primary.opacity(0.5))
                                            .lineLimit(1)
                                            .multilineTextAlignment(.center)
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
                            .refreshable {
                                // Handle pull-to-refresh here
                                viewModel.forceRefresh.toggle()
                            }
                        })
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .overlay(alignment: .topTrailing, content: {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 2, height: scrollerHeight)
                                .overlay(alignment: .trailing, content: {
                                    Text("\(scrollID ?? 0)")
                                        .font(.system(size: 14, design: .rounded).weight(.medium))
                                        .foregroundColor(.primary)
                                        .frame(width: 45, height: 20)
                                        .padding(3)
                                        .background(Color.primary.colorInvert())
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: hideIndicatorLabel ? 65 : -6)
                                        .animation(.bouncy, value: hideIndicatorLabel)
                                })
                                .padding(.trailing,5)
                                .offset(y: indicatorOffset + 40)
                                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
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
        .onAppear {
            let _ = IAP.shared
        }
        .preferredColorScheme(colorScheme)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(item: $selectedImage) { image in
            ZStack {
                SheetContentView(viewModel: viewModel, image: image, viewModelContent: viewModelContent, saveState: $saveState, obj: obj, showPremiumContent: $showPremiumContent)
                    .onDisappear{
                        viewModel.loadImages()
                    }
            }
            .id(image)
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
        .onChange(of: obj.appearance.showPremiumWallpapersOnly){
            viewModel.loadImages()
        }
        .onReceive(viewModel.$forceRefresh) { refresh in
            if refresh {
                viewModel.loadImages()
            }
        }
    }
    
    func totalNewWallpapers() -> Int {
        return viewModel.images.filter { $0.isNew }.count
    }
    
    func getFileName(from urlString: String) -> String {
        if let url = URL(string: urlString) {
            let fileName = url.deletingPathExtension().lastPathComponent
            return fileName
        }
        return ""
    }
}

struct SheetContentView: View {
    @ObservedObject var viewModel: DataViewModel
    let image: ImageModel
    @StateObject var viewModelContent: ContentViewModel
    @Binding var saveState: URLImages.SaveState
    @StateObject var obj: Object
    @State private var imageSize: String = "Fetching file size..."
    @State private var imageFileFormat: String = ""
    @State private var isTapped: Bool = false
    let saveTip = SaveWallpaperTip()
    @SceneStorage("isZooming") var isZooming: Bool = false
    @Binding var showPremiumContent: Bool
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    
                    LargeImageView(image: image, viewModelContent: viewModelContent, importedOverlay: $viewModelContent.importedOverlay)
                    
                    Group {
                        
                        HStack(alignment: .center){
                            if imageSize != "ERROR - FILE DOES NOT EXIST" {
                                
                                if getFileName(from: image.image).contains("p_") {
                                    Image(systemName: "star.square")
                                        .padding(.top, 6)
                                        .foregroundStyle(.yellow)
                                }
                                
                                Text(getFileName(from: image.image)
                                    .replacingOccurrences(of: "p_", with: ""))
                                .padding(.top, 6)
                                .foregroundStyle(getFileName(from: image.image).contains("p_") ? .yellow : .primary)
                                
                                Text(" • ")
                                    .padding(.top, 6)
                            }
                            
                            if imageSize != "ERROR - FILE DOES NOT EXIST" {
                                Text(imageSize)
                                    .padding(.top, 6)
                            } else {
                                
                                VStack {
                                    
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                        .font(.title2)
                                    Text(imageSize)
                                        .foregroundStyle(.red)
                                        .padding(.top, 6)
                                }
                                
                            }
                            
                            if imageSize != "Fetching file size..." {
                                if imageSize != "ERROR - FILE DOES NOT EXIST" {
                                    Text(imageFileFormat.dropFirst(2))
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 6)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .offset(y: 2)
                                }
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.caption)
                        .offset(y: 50)
                        
                        if imageSize != "ERROR - FILE DOES NOT EXIST" {
                            //MARK:  Check if the filename contains "p_" for premium
                            if getFileName(from: image.image).contains("p_") && !showPremiumContent {
                                HStack {
                                    Image(systemName: "star.square")
                                        .font(.title3)
                                        .foregroundStyle(.yellow)
                                    
                                    Text("Premium Required. Unlock In Settings")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                                    
                                }
                                .padding()
                                .offset(y: -30)
                                
                            } else {
                                Button {
                                    isTapped.toggle()
                                    saveImage(importedOverlay: viewModelContent.importedOverlay)
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
                                .offset(y: -30)
                            }
                        }
                    }
                    .opacity(isZooming ? 0 : 1)
                    .animation(.bouncy, value: isZooming)
                    
                }
                .sensoryFeedback(.selection, trigger: isTapped)
                .onAppear {
                    fetchImageSize()
                }
            }
        }
    }
    
    private func getFileName(from urlString: String) -> String {
        if let url = URL(string: urlString) {
            return url.deletingPathExtension().lastPathComponent
        }
        return ""
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
                
                URLSession.shared.dataTask(with: request) { _, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                        if let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String,
                           let size = Int(contentLength) {
                            let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                            
                            // Show "ERROR" if the file size is less than 0.1 MB
                            let fileSizeInMB = Double(size) / (1024 * 1024)
                            let showError = fileSizeInMB < 0.1
                            
                            DispatchQueue.main.async {
                                if showError {
                                    imageSize = "ERROR - FILE DOES NOT EXIST"
                                } else {
                                    imageSize = "Size: \(formattedSize)"
                                }
                                imageFileFormat = " \(modifiedExtension.isEmpty ? "" : ".\(modifiedExtension)")"
                            }
                        }
                    } else {
                        // Handle the case where the file does not exist
                        DispatchQueue.main.async {
                            imageSize = "ERROR - FILE DOES NOT EXIST"
                        }
                    }
                }.resume()
            }
        }
    }
    
    
    
    private func saveImage(importedOverlay: UIImage?) {
        saveState = .saving
        
        guard var urlComponents = URLComponents(string: image.image) else {
            saveState = .idle
            return
        }
        
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".png") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".png", with: "_fullRes.PNG", options: .caseInsensitive)
                } else if imageName.lowercased().hasSuffix(".jpg") {
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
                        var combinedImage: UIImage
                        
                        if let overlayImage = importedOverlay {
                            // Combine original image and imported overlay with resizing
                            combinedImage = originalUIImage.combineWithOverlay(overlayImage, screenSize: UIScreen.main.bounds.size)
                        } else {
                            combinedImage = originalUIImage
                        }
                        
                        // Save the combined image as PNG
                        if let pngData = combinedImage.pngData() {
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

extension UIImage {
    func writeToPhotosAlbum() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    func combineWithOverlay(_ overlayImage: UIImage, screenSize: CGSize) -> UIImage {
        let size = CGSize(width: screenSize.width, height: screenSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        self.draw(in: CGRect(origin: .zero, size: size))
        overlayImage.draw(in: CGRect(origin: .zero, size: size))
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage ?? self
    }
}

struct LargeImageView: View {
    let image: ImageModel
    let frameSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
    let canvasSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    @SceneStorage("isZooming") var isZooming: Bool = false
    @StateObject var viewModelContent: ContentViewModel
    @Binding var importedOverlay: UIImage?
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    
    var fullResImageURL: URL {
        guard var urlComponents = URLComponents(string: image.image) else {
            return URL(string: "")!
        }
        
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".png") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".png", with: "_fullRes.PNG", options: .caseInsensitive)
                } else if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
                } else {
                    modifiedImageName = imageName
                }
                
                pathComponents[pathComponents.count - 1] = modifiedImageName
                urlComponents.path = pathComponents.joined(separator: "/")
                
                guard let modifiedURL = urlComponents.url else {
                    return URL(string: "")!
                }
                
                return modifiedURL
            }
        }
        
        return URL(string: "")!
    }
    
    var body: some View {
        VStack {
            ZStack {
                // Low resolution image loaded first
                WebImage(url: URL(string: image.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frameSize.width, height: frameSize.height)
                
                // Full resolution image loaded
                WebImage(url: fullResImageURL) // Use the full-res image URL
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frameSize.width, height: frameSize.height)
                
                //Overlay image if imported
                if let importedOverlay = importedOverlay {
                    Image(uiImage: importedOverlay)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: frameSize.width, height: frameSize.height)
            .cornerRadius(40)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(.primary, lineWidth: 0.5)
                    .opacity(0.4)
            )
            .padding(.top, 50)
            .addPinchZoom()
            .overlay{
                if showPremiumContent {
                    VStack{
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                if importedOverlay == nil {
                                    viewModelContent.showOverlayPickerSheet.toggle()
                                } else {
                                    importedOverlay = nil
                                }
                            } label: {
                                Image(systemName: importedOverlay == nil ? "plus.circle.fill" : "trash.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(importedOverlay == nil ? .white : .red)
                                    .shadow(radius: 2)
                                    .padding(5)
                                    .background{
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                    }
                            }
                            .padding(.top, 50)
                            .padding()
                            .padding(.trailing, 5)
                        }
                        
                        Spacer()
                        
                    }
                    .opacity(isZooming ? 0 : 1)
                    .animation(.bouncy, value: isZooming)
                }
            }
            .fullScreenCover(isPresented: $viewModelContent.showOverlayPickerSheet) {
                fullScreenImagePickerCover(for: $viewModelContent.importedOverlay) { images in
                    viewModelContent.importedOverlay = images.first
                }
            }
            .frame(width: canvasSize.width)
            .ignoresSafeArea()
            .customPresentationWithPrimaryBackground(detent: .large, backgroundColorOpacity: 1.0)
            
            Spacer()
        }
    }
    
    private func fullScreenImagePickerCover(for binding: Binding<UIImage?>, completion: @escaping ([UIImage]) -> Void) -> some View {
        PhotoPicker(filter: .images, limit: 1) { results in
            PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                if let error = errorOrNil {
                    print(error)
                }
                if let images = imagesOrNil {
                    completion(images)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    @ViewBuilder
    func customFrameBasedOnCondition(obj: Object) -> some View {
        let columns: CGFloat = obj.appearance.showTwoWallpapers ? 2.5 : 4
        customFrame(columns: columns)
    }
    
    func customFrame(columns: CGFloat, borderThickness: CGFloat = 0.5, borderColor: Color = .primary) -> some View {
        let width = UIScreen.main.bounds.width / columns
        let height = UIScreen.main.bounds.height / columns
        
        return self
            .frame(width: width, height: height)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(columns == 2.5 ? 25 : 15)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: columns == 2.5 ? 25 : 15)
                    .stroke(borderColor, lineWidth: borderThickness)
                    .opacity(0.4)
            )
            .scrollTransition(.animated.threshold(.visible(0.1))) { content, phase in
                content
                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
            }
    }
}




