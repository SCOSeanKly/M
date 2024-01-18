//
//  URLImageView.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import TipKit
import SwiftUIX


struct URLImages: View {
    @StateObject var viewModelData: DataViewModel
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
        return viewModelData.images.count
    }
    
    @State private var isTapped: Bool = false
    
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
    
    @Binding var showPremiumContent: Bool
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    
    
    var body: some View {
        ZStack {
            VStack {
                
                ButtonView(obj: obj, viewModelData: viewModelData, showPremiumContent: $showPremiumContent)
                
                if !viewModelData.images.isEmpty {
                    ScrollViewReader(content: { proxy in
                        ScrollView(.vertical, showsIndicators: true) {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: obj.appearance.showTwoWallpapers ? 2 : 3), spacing: 30) {
                                ForEach(viewModelData.images.indices.reversed(), id: \.self) { index in
                                    VStack {
                                        Button {
                                            isTapped.toggle()
                                            selectedImage = viewModelData.images[index]
                                            isSheetPresented = true
                                            saveState = .idle
                                            
                                        } label: {
                                            WebImage(url: URL(string: viewModelData.images[index].image))
                                                .resizable()
                                                .customFrameBasedOnCondition(obj: obj)
                                                .overlay {
                                                    //MARK: Add a star if wallpaper is premium
                                                    if viewModelData.images[index].image.contains("p_") {
                                                        StarView()
                                                    }
                                                    
                                                    if viewModelData.images[index].isNew {
                                                        NewWallAddedView()
                                                            .customFrameBasedOnCondition(obj: obj)
                                                    }
                                                }
                                        }
                                        
                                        let fileName = getFileName(from: viewModelData.images[index].image)
                                        
                                        // Check if the fileName starts with "p_" or "w_" and replace with nil
                                        let updatedFileName = fileName
                                            .replacingOccurrences(of: "p_", with: "")
                                            .replacingOccurrences(of: "w_", with: "")
                                            .uppercased()
                                        
                                        Text(updatedFileName)
                                            .font(.system(size: 10))
                                            .foregroundColor(.primary.opacity(0.5))
                                            .lineLimit(1)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .padding(10)
                            .scrollTargetLayout()
                            
                            Spacer()
                                .frame(height: 100)
                        }
                        .refreshable {
                            // Handle pull-to-refresh here
                            viewModelData.forceRefresh.toggle()
                        }
                    })
                    
                } else {
                    // Show loading images view when no images have been loaded yet
                    LoadingImagesView()
                }
                
                Spacer()
            }
        }
        .onAppear {
            let _ = IAP.shared
        }
        .preferredColorScheme(colorScheme)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(item: $selectedImage) { image in
            ZStack {
                SheetContentView(viewModel: viewModelData, image: image, viewModelContent: viewModelContent, saveState: $saveState, obj: obj, showPremiumContent: $showPremiumContent)
                    .onDisappear{
                        viewModelData.loadImages()
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
            viewModelData.loadImages()
        }
        .onReceive(viewModelData.$forceRefresh) { refresh in
            if refresh {
                viewModelData.loadImages()
            }
        }
    }
    
    func totalNewWallpapers() -> Int {
        return viewModelData.images.filter { $0.isNew }.count
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
    @StateObject var viewModel: DataViewModel
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
    let error: String = "ERROR - FILE DOES NOT EXIST"
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    
                    LargeImageView(image: image, viewModelContent: viewModelContent, importedOverlay: $viewModelContent.importedOverlay, showPremiumContent: $showPremiumContent)
                    
                    Group {
                        HStack(alignment: .center){
                            if imageSize != error {
                                
                                // Shows premium star symbol when image contains "p_"
                                if getFileName(from: image.image).contains("p_") {
                                    Image(systemName: "crown.fill")
                                        .padding(.top, 6)
                                        .foregroundStyle(.yellow.gradient)
                                }
                                
                                Text(getFileName(from: image.image.uppercased())
                                    .replacingOccurrences(of: "P_", with: "")
                                    .replacingOccurrences(of: "W_", with: ""))
                                .padding(.top, 6)
                                .foregroundStyle(getFileName(from: image.image).contains("p_") ? .yellow : .primary)
                                
                                Text(" • ")
                                    .padding(.top, 6)
                            }
                            
                            if imageSize != error {
                                Text(getFileName(from: image.image).contains("w_") ?
                                     "Download QR Code" : imageSize)
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
                                if imageSize != error {
                                    
                                    if !getFileName(from: image.image).contains("w_") {
                                        Text(imageFileFormat.dropFirst(2))
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 6)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .offset(y: 2)
                                    }
                                }
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.caption)
                        .offset(y: 50)
                        
                        if imageSize != error {
                            //MARK:  Check if the filename contains "p_" for premium
                            if getFileName(from: image.image).contains("p_") && !showPremiumContent {
                                HStack {
                                    CrownView()
                                    
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
    
    @Binding var showPremiumContent: Bool
    
    @StateObject private var metadataViewModel = ImageMetadataViewModel()
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    
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
                    .onAppear {
                        // Fetch metadata when the premium content image appears
                        metadataViewModel.fetchImageMetadata(from: fullResImageURL)
                    }
                // Dont load full res image if image is Widgy
                if !image.image.contains("w_") {
                    // Show Full Res Image if Premium is unlocked with IAP
                    if showPremiumContent {
                        WebImage(url: fullResImageURL) // Use the full-res image URL
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: frameSize.width, height: frameSize.height)
                    } else if !image.image.contains("p_") {
                        // Show Full Res Image of non-premium image
                        WebImage(url: fullResImageURL) // Use the full-res image URL
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: frameSize.width, height: frameSize.height)
                    }
                }
                // Overlay image if one is imported
                if let importedOverlay = importedOverlay {
                    Image(uiImage: importedOverlay)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .onDisappear {
                // Reset metadata when the view disappears to avoid showing old metadata when reappearing
                metadataViewModel.imageMetadata = nil
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
                if !image.image.contains("w_") {
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
            }
            .fullScreenCover(isPresented: $viewModelContent.showOverlayPickerSheet) {
                fullScreenImagePickerCover(for: $viewModelContent.importedOverlay) { images in
                    viewModelContent.importedOverlay = images.first
                }
            }
            .frame(width: canvasSize.width)
            .ignoresSafeArea()
            .customPresentationWithPrimaryBackground(detent: .large, backgroundColorOpacity: 1.0)
            
            if metadataViewModel.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(0.6)
                    
                    Text(" Checking for AI Prompt")
                    
                }
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(.primary)
                .padding(5)
                .padding(.horizontal, 5)
                .background(.ultraThinMaterial.opacity(0.7))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            if let metadata = metadataViewModel.imageMetadata {
                VStack {
                    let sortedKeys = metadata.keys.sorted(by: { ($0 as String).compare($1 as String) == .orderedAscending })
                    ForEach(sortedKeys, id: \.self) { key in
                        if let value = metadata[key] {
                            
                            Button {
                                UIPasteboard.general.string = "\(String(describing: value))"
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    alert.present()
                                }
                            } label: {
                                Text("\(String(describing: value))")
                                    .font(.system(size: 12, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                                    .padding(5)
                                    .background(.ultraThinMaterial.opacity(0.7))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.primary, lineWidth: 0.5)
                                            .opacity(0.4)
                                    )
                            }
                            .buttonStyle(.plain)
                          
                        }
                    }
                }
                .alert(alertConfig: $alert) {
                    alertPreferences(title: "Copied to Clipboard!",
                                     imageName: "checkmark.circle")
                }
                .frame(width: frameSize.width)
                .padding(.bottom, 5)
            }
            
            Spacer()
        }
    }
    
    private func alertPreferences(title: String, imageName: String) -> some View {
        Text("\(Image(systemName: imageName)) \(title)")
            .foregroundStyle(.primary)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.primary.colorInvert())
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss()
                }
            })
            .onTapGesture {
                alert.dismiss()
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




