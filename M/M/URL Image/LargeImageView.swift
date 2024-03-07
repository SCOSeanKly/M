//
//  LargeImageView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUIX

struct LargeImageView: View {
    let image: ImageModel
    @StateObject var viewModelContent: ContentViewModel
    @StateObject var obj: Object
    @StateObject private var metadataViewModel = ImageMetadataViewModel()
    @Binding var showPremiumContent: Bool
    @State private var isTapped: Bool = false
    @State private var isTappedAnimation: Bool = false
    @Binding var isZooming: Bool
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var premiumRequiredAlert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @Binding var isNoAIPromptVisible: Bool
    @Binding var isNoAIPromptVisibleAnimation: Bool
    let frameSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
    let canvasSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var fullResImageURL: URL? {
        guard let imageURL = URL(string: image.image) else {
            return nil
        }
        
        var urlComponents = URLComponents(url: imageURL, resolvingAgainstBaseURL: false)
        
        if let pathComponents = urlComponents?.path.components(separatedBy: "/"),
           let imageName = pathComponents.last {
            
            let modifiedImageName: String
            if imageName.lowercased().hasSuffix(".jpg") {
                modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
            } else {
                modifiedImageName = imageName
            }
            
            var modifiedPathComponents = pathComponents
            modifiedPathComponents[modifiedPathComponents.count - 1] = modifiedImageName
            urlComponents?.path = modifiedPathComponents.joined(separator: "/")
            
            return urlComponents?.url
        }
        
        return nil
    }
    @Binding var isShowingGradientView: Bool
    @Binding var importedBackground: UIImage?
    @Binding var selectedImage: ImageModel?
    @Binding var activeTab: Tab
    

    
    var body: some View {
        VStack {
            ZStack {
                if showPremiumContent && !image.image.contains("w_") && obj.appearance.showFullResPreview {
                    VStack {
                        ProgressView()
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundColor(.primary)
                    }
                    WebImage(url: fullResImageURL, options: [.progressiveLoad])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .addPinchZoom(isZooming: $isZooming)
                } else {
                    WebImage(url: URL(string: image.image))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .onAppear {
                // Fetch metadata when the premium content image appears
                if let fullResURL = fullResImageURL {
                    metadataViewModel.fetchImageMetadata(from: fullResURL)
                } else {
                    print("Metadata not found in fullRes Image")
                }
            }
            .onDisappear {
                // Reset metadata when the view disappears to avoid showing old metadata when reappearing
                metadataViewModel.imageMetadata = nil
            }
            .fullScreenCover(isPresented: $viewModelContent.showOverlayPickerSheet) {
                fullScreenImagePickerCover(for: $viewModelContent.importedOverlay) { images in
                    viewModelContent.importedOverlay = images.first
                }
            }
            .overlay{
                VStack{
                  
                    Spacer()
                    
                    if obj.appearance.showAIPromptText && !image.image.contains("w_"){
                        if metadataViewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                    .scaleEffect(0.6)
                                
                                Text(" Checking for AI prompt")
                                
                            }
                            .modifier(AICustomTextModifier(customPadding: 5, cornerRadius: 50, strokeOpacity: 0.0))
                            .onDisappear {
                                isNoAIPromptVisible = true
                            }
                        }
                        
                        if let metadata = metadataViewModel.imageMetadata {
                            VStack {
                                let sortedKeys = metadata.keys.sorted(by: { ($0 as String).compare($1 as String) == .orderedAscending })
                                ForEach(sortedKeys, id: \.self) { key in
                                    if let value = metadata[key] {
                                        
                                        Button {
                                            
                                            isTappedAnimation.toggle()
                                            UIPasteboard.general.string = "\(String(describing: value))"
                                            isTapped.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                alert.present()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                isTappedAnimation.toggle()
                                            }
                                            
                                        } label: {
                                            Text("\(String(describing: value))")
                                                .modifier(AICustomTextModifier(customPadding: 5, cornerRadius: 10, strokeOpacity: 0.4))
                                                .scaleEffect(isTappedAnimation ? 0.9 : 1, anchor: .center)
                                                .animation(.bouncy, value: isTappedAnimation)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .frame(width: frameSize.width)
                            .alert(alertConfig: $alert) {
                                alertPreferences(title: "Copied to Clipboard!",
                                                 imageName: "checkmark.circle")
                            }
                        } else {
                            if isNoAIPromptVisible {
                                NoAIPromptView(isNoAIPromptVisible: $isNoAIPromptVisible, isNoAIPromptVisibleAnimation: $isNoAIPromptVisibleAnimation)
                            }
                        }
                    }
                    
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .opacity(isZooming ? 0 : 1)
                .animation(.smooth, value: isZooming)
            }
            .overlay{
              
                    VStack {
                        
                        HStack{
                            
                            Spacer()
                            
                            //MARK: Open gradient editor
                            UltraThinButton(action: {
                                
                                if showPremiumContent {
                                    if let fullResURL = fullResImageURL {
                                        // Load the image asynchronously
                                        SDWebImageDownloader.shared.downloadImage(with: fullResURL) { image, _, _, _ in
                                            // Once the image is loaded, update importedBackground
                                            if let loadedImage = image {
                                                DispatchQueue.main.async {
                                                    importedBackground = loadedImage
                                                    // After updating importedBackground, toggle isShowingGradientView
                                                    activeTab = .creator
                                                    selectedImage = nil
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    premiumRequiredAlert.present()
                                }
                                 
                            }, systemName: "slider.horizontal.3", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: showPremiumContent ? false : true, overlaySymbol: "crown.fill", overlaySymbolColor: .yellow)
                        }
                        
                        Spacer()
                        
                    }
                    .alert(alertConfig: $premiumRequiredAlert) {
                        alertPreferencesPremiumrequired(title: "Premium Required!", imageName: "crown.fill")
                    }
                    .padding()
                    .padding(.trailing)
                    .padding(.top, 40)
                
            }
        }
        .sensoryFeedback(.selection, trigger: isTapped)
    }
    
    private func alertPreferencesPremiumrequired(title: String, imageName: String) -> some View {
        VStack {
            
            Text("\(Image(systemName: imageName)) \(title)")
            
            Text("Open settings to unlock premium")
                .font(.system(size: 12, design: .rounded))
                .padding(.top, 5)
            
        }
        .foregroundStyle(.black)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.yellow)
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
