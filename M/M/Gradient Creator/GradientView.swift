//
//  GradientView.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 12/06/2023.
//

import SwiftUI
import Photos

struct GradientView: View {
    
    @State private var showGradientBgPickerSheet = false
    @Binding var importedBackground: UIImage?
    @State private var showImageOverlayPickerSheet = false
    @State private var importedImageOverlay: UIImage? = nil
    @State private var gradientColors = [Color]()
    @AppStorage("SelectedColorCount") private var selectedColorCount = 4
    @State private var refreshButtonTapped = false
    @State private var gradientStyle: GradientStyle = .angular
    @Binding var isShowingGradientView: Bool
    @State private var isSavingImage = false
    @State private var isShowingGradientSavedNotification: Bool = false
    @State private var gradientBlur: CGFloat = 0
    @State private var gradientScale: CGFloat = 1.0
    @State private var gradientRotation: Angle = .zero
    @State private var gradientOffsetX: CGFloat = 0
    @State private var gradientOffsetY: CGFloat = 0
    @State private var bgColor = (Color.black)
    @State private var showGradientControl: Bool = false
    @State private var blendModeGradient: BlendMode = .normal
    @State private var pixellate: CGFloat = 1
    @State private var amplitude: CGFloat = 0
    @State private var frequency: CGFloat = 200
    @State private var showHalfBlur: Bool = false
    @State private var gradientHue: CGFloat = 0
    @State private var gradientSaturation: CGFloat = 1
    @State private var gradientBrightness: CGFloat = 0
    @State private var gradientContrast: CGFloat = 1
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var showPopoverGradientWall: Bool = false
    @State private var isTapped: Bool = false
    @State private var invertGradient: Bool = false
    @State private var blendModeImportedBackground: BlendMode = .normal
    @State private var showOverlaysURLView: Bool = false
    @StateObject var viewModelHeader = DataViewModelOverlays()
    @State private var selectedURLOverlayImages: [ImageModelOverlayImage]
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @State private var isZooming: Bool = false
    @StateObject var obj = Object()
    @State private var allowPixellateEffect: Bool = false
    
    
    
    enum GradientStyle: String, CaseIterable, Identifiable {
        case linear, radial, angular
        var id: String { self.rawValue }
    }
    
    init(isShowingGradientView: Binding<Bool>, importedBackground: Binding<UIImage?>) {
        _importedBackground = importedBackground
        _isShowingGradientView = isShowingGradientView
        _selectedURLOverlayImages = State(initialValue: [])
        _gradientColors = State(initialValue: generateRandomColors(count: 6))
        isShowingGradientSavedNotification = false
    }
    
    
    var body: some View {
        
        //MARK: Image layers
        ZStack {
            
            //MARK: Rearmost background colour
            Rectangle()
                .foregroundColor(bgColor)
            
            //MARK: Gradient Background - 1
            GradientBackground(gradientColors: selectedColors(), gradientStyle: gradientStyle, refreshButtonTapped: $refreshButtonTapped, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
            
            //MARK: Gradient Background - 2
            if blendModeGradient != .normal {
                GradientBackground(gradientColors: selectedColors(), gradientStyle: gradientStyle, refreshButtonTapped: $refreshButtonTapped, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
                    .blendMode(blendModeGradient)
            }
            //MARK: Adds a blurred overlay to gradient views
            GradientBlurView(gradientBlur: $gradientBlur)
            
            //MARK: URL Overlay effects
            ForEach(selectedURLOverlayImages) { image in
                OverlaysImageView(image: image)
            }
            
            //MARK: Overlay image from photos
            GradientOverlayImageView(importedImageOverlay: $importedImageOverlay)
            
            //MARK: Adds a half blur on the left side
            HalfBlurView(showHalfBlur: $showHalfBlur)
            
        }
        
        .frame(width: screenWidth, height: screenHeight)
        .clipShape(Rectangle())
        .ignoresSafeArea()
        .addPinchZoom(isZooming: $isZooming)
        .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .global)
            .onEnded { value in
                if value.translation.height > 0 {
                    isShowingGradientView = false
                }
            })
        .onTapGesture (count: 2) {
            feedback()
            isSavingImage = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                saveImageToPhotoLibrary()
                
                DispatchQueue.main.async {
                    alert.present()
                    
                    performDelayedAction(after: 2.0) {
                        alert.dismiss()
                        
                        performDelayedAction(after: 0.3) {
                            isSavingImage = false
                        }
                    }
                }
            }
        }
        .alert(alertConfig: $alert) {
            alertPreferences(title: "Saved Successfully!", imageName: "checkmark.circle")
        }
        .onTapGesture {
            withAnimation(.bouncy) {
                showGradientControl.toggle()
            }
        }
        .overlay{
            if !isZooming {
                //MARK: Screen Buttons
                OverlayButtonsView(isSavingImage: $isSavingImage, showGradientControl: $showGradientControl, isTapped: $isTapped, isShowingGradientView: $isShowingGradientView, gradientStyle: $gradientStyle, blendModeGradient: $blendModeGradient, showGradientBgPickerSheet: $showGradientBgPickerSheet, showImageOverlayPickerSheet: $showImageOverlayPickerSheet, refreshButtonTapped: $refreshButtonTapped, alert: $alert, importedBackground: $importedBackground, showOverlaysURLView: $showOverlaysURLView, selectedURLOverlayImages: $selectedURLOverlayImages, importedImageOverlay: $importedImageOverlay)
            }
        }
        .sheet(isPresented: $showGradientControl){
            //MARK: These are the buttons and control sliders
            AdjustmentSettingsView(isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, showPopoverGradientWall: $showPopoverGradientWall, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
        }
        .fullScreenCover(isPresented: $showGradientBgPickerSheet) {
            createFullScreenCover(for: $importedBackground) { BgImage in
                importedBackground = BgImage.first
            }
        }
        .fullScreenCover(isPresented: $showImageOverlayPickerSheet) {
            createFullScreenCover(for: $importedImageOverlay) { overlayImage in
                importedImageOverlay = overlayImage.first
            }
        }
        .sheet(isPresented: $showOverlaysURLView) {
            LoadJSONView(viewModelHeader: viewModelHeader, selectedURLOverlayImages: $selectedURLOverlayImages, showOverlaysURLView: $showOverlaysURLView, obj: obj)
        }
    }
    
    func alertPreferences(title: String, imageName: String) -> some View {
        Text("\(Image(systemName: imageName)) \(title)")
            .foregroundStyle(.white)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.green.gradient)
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
    
    private func createFullScreenCover(for binding: Binding<UIImage?>, completion: @escaping ([UIImage]) -> Void) -> some View {
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
    
    //MARK: Save image function PNG
    func saveImageToPhotoLibrary() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale // Use the screen scale for full resolution
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds, format: format)
        let image = renderer.image { context in
            // Add .withRenderingMode(.alwaysOriginal) to capture the original image
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }.withRenderingMode(.alwaysOriginal) // Apply .withRenderingMode(.alwaysOriginal) to the captured image
        
        PHPhotoLibrary.shared().performChanges({
            let pngData = image.pngData() // Convert the image to PNG data
            if let pngData = pngData {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: pngData, options: nil)
            }
        }) { _, error in
            if let error = error {
                print("Failed to save image to photo library:", error)
            } else {
                print("Image saved to photo library successfully.")
            }
        }
    }
    
    // Timer used to close the exported image notification
    func performDelayedAction(after interval: TimeInterval, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: action)
    }
    
    // Generate random colours onAppear
    func generateRandomColors(count: Int) -> [Color] {
        (0..<count).map { _ in
            Color(red: Double.random(in: 0...1),
                  green: Double.random(in: 0...1),
                  blue: Double.random(in: 0...1))
        }
    }
    
    // Generate gradients
    func generateGradient() {
        let selectedColors = gradientColors.prefix(selectedColorCount)
        gradientColors = selectedColors.shuffled() + gradientColors.dropFirst(selectedColorCount)
        refreshButtonTapped.toggle()
    }
    
    // Get the selected colors for the gradient
    func selectedColors() -> [Color] {
        Array(gradientColors.prefix(selectedColorCount))
    }
    
    func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}







