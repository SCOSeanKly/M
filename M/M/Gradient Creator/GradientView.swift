//
//  GradientView.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 12/06/2023.
//

import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins



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
    @State private var blendModeEffects: BlendMode = .normal
    @State private var pixellate: CGFloat = 1
    @State private var amplitude: CGFloat = 0
    @State private var frequency: CGFloat = 200
    @State private var showHalfBlur: Bool = false
    @State private var halfBlurLeft: Bool = false
    @State private var halfBlurShadowOpacity: CGFloat = 0.5
    @State private var gradientHue: CGFloat = 0
    @State private var gradientSaturation: CGFloat = 1
    @State private var gradientBrightness: CGFloat = 0
    @State private var gradientContrast: CGFloat = 1
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
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
    @Binding var activeTab: Tab
    @State private var importedBackgroundOpacity: CGFloat = 1
    @State private var effectsOpacity: CGFloat = 1
    @State private var hideGradient: Bool = false
    @State private var importedBackgroundBlur: CGFloat = 0
    @State private var importedBackgroundHue: CGFloat = 0
    @State private var importedBackgroundSaturation: CGFloat = 1
    @State private var importedBackgroundBrightness: CGFloat = 0
    @State private var importedBackgroundContrast: CGFloat = 1
    
    
    enum GradientStyle: String, CaseIterable, Identifiable {
        case linear, radial, angular
        var id: String { self.rawValue }
    }
    
    init(isShowingGradientView: Binding<Bool>, importedBackground: Binding<UIImage?>, activeTab: Binding<Tab>) {
        _activeTab = activeTab
        _importedBackground = importedBackground
        _isShowingGradientView = isShowingGradientView
        _selectedURLOverlayImages = State(initialValue: [])
        _gradientColors = State(initialValue: generateRandomColors(count: 6))
        isShowingGradientSavedNotification = false
    }
    
    @State private var showOverlaysView: Bool = false
    
    
    var body: some View {
        
        //MARK: Image layers
        ZStack {
            //MARK: Rearmost background colour
            Rectangle()
                .foregroundColor(hideGradient ? .clear : bgColor)
            
            if !isSavingImage {
                Checkerboard(rows: 58.5, columns: 27)
                    .fill(.gray.opacity(0.2))
                    .frame(width: screenWidth, height: screenHeight)
                    .ignoresSafeArea()
            }
            
            if !hideGradient {
                //MARK: Gradient Background - 1
                GradientBackground(gradientColors: selectedColors(), gradientStyle: gradientStyle, refreshButtonTapped: $refreshButtonTapped, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
                
                //MARK: Gradient Background - 2
                if blendModeGradient != .normal {
                    GradientBackground(gradientColors: selectedColors(), gradientStyle: gradientStyle, refreshButtonTapped: $refreshButtonTapped, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
                        .blendMode(blendModeGradient)
                }
                
                //MARK: Adds a blurred overlay to gradient views
                BlurView(blurBinding: $gradientBlur)
                
                //MARK: Imported Background
                if let background = importedBackground {
                    Image(uiImage: background)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .hueRotation(Angle(degrees: importedBackgroundHue))
                        .saturation(importedBackgroundSaturation)
                        .contrast(importedBackgroundContrast)
                        .brightness(importedBackgroundBrightness)
                        .blendMode(blendModeImportedBackground)
                        .overlay {
                            //MARK: Adds a blurred overlay to gradient views
                            BlurView(blurBinding: $importedBackgroundBlur)
                        }
                }
            }
            
            //MARK: URL Overlay effects
            OverlaysView(selectedURLOverlayImages: $selectedURLOverlayImages, importedImageOverlay: $importedImageOverlay, blendModeEffects: $blendModeEffects, effectsOpacity: $effectsOpacity)
            
            //MARK: Overlay image from photos
            GradientOverlayImageView(importedImageOverlay: $importedImageOverlay)
            
            //MARK: Adds a half blur on the left side
            HalfBlurView(showHalfBlur: $showHalfBlur, halfBlurLeft: $halfBlurLeft, halfBlurShadowOpacity: $halfBlurShadowOpacity)
            
        }
        .background(.clear)
        .frame(width: screenWidth, height: screenHeight)
        .clipShape(Rectangle())
        .ignoresSafeArea(.all)
        .addPinchZoom(isZooming: $isZooming)
        .alert(alertConfig: $alert) {
            alertPreferences(title: !hideGradient ? "Saved Successfully!" : "Exported Successfully!",
                             imageName: "checkmark.circle")
        }
        .alert(alertConfig: $alertError) {
            alertPreferences(title: "Error Saving!",
                             imageName: "exclamationmark.triangle")
        }
        .onTapGesture {
            withAnimation(.snappy) {
                showGradientControl.toggle()
            }
        }
        .overlay{
            if !isZooming {
                //MARK: Screen Buttons
                OverlayButtonsView(isSavingImage: $isSavingImage, showGradientControl: $showGradientControl, isTapped: $isTapped, isShowingGradientView: $isShowingGradientView, gradientStyle: $gradientStyle, blendModeGradient: $blendModeGradient, showGradientBgPickerSheet: $showGradientBgPickerSheet, showImageOverlayPickerSheet: $showImageOverlayPickerSheet, refreshButtonTapped: $refreshButtonTapped, alert: $alert, alertError: $alertError, importedBackground: $importedBackground, showOverlaysURLView: $showOverlaysURLView, selectedURLOverlayImages: $selectedURLOverlayImages, importedImageOverlay: $importedImageOverlay, activeTab: $activeTab, hideGradient: $hideGradient)
            }
        }
        .sheet(isPresented: $showGradientControl){
            //MARK: These are the buttons and control sliders
            AdjustmentSettingsView(isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, showPopoverGradientWall: $showPopoverGradientWall, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, blendModeEffects: $blendModeEffects, allowPixellateEffect: $allowPixellateEffect, importedBackgroundOpacity: $importedBackgroundOpacity, effectsOpacity: $effectsOpacity, hideGradient: $hideGradient, importedBackgroundBlur: $importedBackgroundBlur, importedBackgroundHue: $importedBackgroundHue, importedBackgroundSaturation: $importedBackgroundSaturation, importedBackgroundBrightness: $importedBackgroundBrightness,  importedBackgroundContrast: $importedBackgroundContrast, halfBlurLeft: $halfBlurLeft, halfBlurShadowOpacity: $halfBlurShadowOpacity)
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







