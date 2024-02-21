//
//  GradientView.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 12/06/2023.
//

import SwiftUI
import Photos

struct GradientView: View {
    
    
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let sliderHeight: CGFloat = 10
    let bottomPadding: CGFloat = 8
    let horizontalPadding: CGFloat = 8
    let scaleEffect: CGFloat = 1
    let startDate: Date = .init()
    
    @State private var showBgPickerSheet = false
    @State private var importedBackground: UIImage? = nil
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
    @State private var showButtons = true
    @State private var timer: Timer?
    @State private var blendMode: BlendMode = .normal
    @State private var pixellate: CGFloat = 1
    @State private var speed: CGFloat = 0
    @State private var amplitude: CGFloat = 5
    @State private var frequency: CGFloat = 200
    @State private var showHalfBlur: Bool = false
    @State private var gradientHue: CGFloat = 0
    @State private var gradientSaturation: CGFloat = 1
    @State private var gradientBrightness: CGFloat = 0
    @State private var gradientContrast: CGFloat = 1
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var showPopoverGradientWall: Bool = false
    @State private var isTapped: Bool = false
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    
    enum GradientStyle: String, CaseIterable, Identifiable {
        case linear, radial, angular
        var id: String { self.rawValue }
    }
    
    init(isShowingGradientView: Binding<Bool>) {
        _isShowingGradientView = isShowingGradientView
        _gradientColors = State(initialValue: generateRandomColors(count: 6))
        isShowingGradientSavedNotification = false
    }
    
    var body: some View {
        ZStack {
            //MARK: Image layers
            Group {
                ZStack {
                    Group {
                        Rectangle()
                            .foregroundColor(bgColor)
                        
                        //MARK: This is the view I want to export as an image
                        GradientBackground(gradientColors: selectedColors(), refreshButtonTapped: $refreshButtonTapped, gradientStyle: gradientStyle, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, speed: $speed, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast)
                        
                        if blendMode != .normal {
                            GradientBackground(gradientColors: selectedColors(), refreshButtonTapped: $refreshButtonTapped, gradientStyle: gradientStyle, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, speed: $speed, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast)
                                .blendMode(blendMode)
                        }
                    }
                    
                    if gradientBlur > 0.001 {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background {
                                TransparentBlurView(removeAllFilters: true)
                                    .blur(radius: gradientBlur, opaque: true)
                                    .frame(width: screenWidth, height: screenHeight)
                            }
                    }
                    
                    if let imageOverlay = importedImageOverlay {
                        Image(uiImage: imageOverlay)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width)
                            .shadow(radius: 5, x: 3)
                    }
                    
                    if showHalfBlur {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background {
                                TransparentBlurView(removeAllFilters: true)
                                    .blur(radius: 25, opaque: true)
                                    .frame(width: screenWidth, height: screenHeight)
                            }
                            .shadow(radius: 10)
                            .offset(x: -UIScreen.main.bounds.width * 0.5)
                    }
                }
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
            }
        }
        .overlay{
            //MARK: Top Buttons
            Group {
                if !isSavingImage && !showGradientControl{
                    VStack {
                        HStack {
                            
                            UltraThinButton(action: {
                                isTapped.toggle()
                                isShowingGradientView.toggle()
                            }, systemName: "xmark.circle", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true)
                    
                            Spacer()
                            
                            Picker("Gradient Style", selection: $gradientStyle) {
                                ForEach(GradientStyle.allCases) { style in
                                    Text(style.rawValue.capitalized)
                                        .tag(style)
                                }
                            }
                            .shadow(radius: 3)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Picker("Blend Mode", selection: $blendMode) {
                                Group {
                                    Text("None").tag(BlendMode.normal)
                                    Text("Difference").tag(BlendMode.difference)
                                    Text("Exclusion").tag(BlendMode.exclusion)
                                    Text("Hard Light").tag(BlendMode.hardLight)
                                    Text("Soft Light").tag(BlendMode.softLight)
                                    Text("Color Burn").tag(BlendMode.colorBurn)
                                }
                                Group {
                                    Text("Color Dodge").tag(BlendMode.colorDodge)
                                    Text("Darken").tag(BlendMode.darken)
                                    Text("Lighten").tag(BlendMode.lighten)
                                    Text("Multiply").tag(BlendMode.multiply)
                                    Text("Overlay").tag(BlendMode.overlay)
                                    Text("Screen").tag(BlendMode.screen)
                                    Text("Plus Lighter").tag(BlendMode.plusLighter)
                                    
                                }
                            }
                            .shadow(radius: 3)
                        }
                        
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showBgPickerSheet.toggle()
                            }, systemName: "photo.circle", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showImageOverlayPickerSheet.toggle()
                            }, systemName: "photo.circle.fill", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            UltraThinButton(action: {
                                generateGradient()
                            }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true)
                            .padding(.bottom)
                         
                            .padding(.bottom)
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .font(.footnote)
                    .tint(.white)
                }
                 
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showGradientControl){
            //MARK: These are the buttons and control sliders
            
            if !isSavingImage {
                        //MARK: Title
                        HStack {
                            Text("Adjustment Settings")
                                .font(.headline)
                            
                            Spacer()
                            
                            AnimatedButton(action: {
                                gradientBlur = 0
                                gradientScale = 1
                                gradientRotation = .zero
                                gradientOffsetX = 0
                                gradientOffsetY = 0
                                importedBackground = nil
                                importedImageOverlay = nil
                                pixellate = 1
                                speed = 0
                                amplitude = 5
                                frequency = 200
                                showHalfBlur = false
                                gradientHue = 0
                                gradientSaturation = 1
                                gradientBrightness = 0
                                gradientContrast = 1
                            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                            
                            Button {
                                isTapped.toggle()
                                showPopoverGradientWall.toggle()
                            } label: {
                                Label("",systemImage: showPopoverGradientWall ? "xmark.circle": "info.circle")
                                    .font(.title2)
                                    .popover(isPresented: $showPopoverGradientWall) {
                                        PopOverGradientWallView()
                                    }
                            }
                            .buttonStyle(.plain)
                            .contentTransition(.symbolEffect(.replace))
                            .sensoryFeedback(.selection, trigger: isTapped)
                            
                        }
                        .padding(.horizontal)
                        .padding(.horizontal, 4)
                        .padding(.top)
                        
                        ScrollView {
                            
                                //MARK: Horizontal and Vertical Position Sliders
                                HStack{
                                    
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.title2)
                                        .padding(.trailing)
                                        .offset(y: 12)
                                    VStack {
                                        
                                        Text("\(Int((gradientOffsetX / 1000) * 100))%")
                                            .font(.footnote)
                                        
                                        CustomSlider(value: $gradientOffsetX, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                        }
                                        .frame(width: sliderScale.width * 0.28)
                                        
                                    }
                                 
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.arrow.down")
                                        .font(.title2)
                                        .padding(.trailing)
                                        .offset(x: 15, y: 12)
                                    VStack {  Text("\(Int((gradientOffsetY / 1000) * 100))%")
                                            .font(.footnote)
                                        
                                        CustomSlider(value: $gradientOffsetY, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                        }
                                        .frame(width: sliderScale.width * 0.28)
                                    }
                                    
                                    AnimatedButton(action: {
                                        gradientOffsetX = 0
                                        gradientOffsetY = 0
                                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                                    .padding(.leading, 8)
                                    .offset(y: 12)
                                }
                                .padding(.horizontal)
                                .padding(.vertical)
                             
                                
                                //MARK: Hue Slider
                                SliderView(systemName: "camera.filters", sliderTitle: "", blurSystemName: false, value: $gradientHue, inValue: -180, outValue: 180, resetValue: 0)
                                
                                //MARK: Sat Slider
                                SliderView(systemName: "drop.halffull", sliderTitle: "", blurSystemName: false, value: $gradientSaturation, inValue: 0, outValue: 2, resetValue: 1)
                                
                                //MARK: Contrast Slider
                                SliderView(systemName: "circle.lefthalf.striped.horizontal", sliderTitle: "", blurSystemName: false, value: $gradientContrast, inValue: 0.1, outValue: 3, resetValue: 1)
                                //MARK: Brightneass Slider
                                SliderView(systemName: "sun.max", sliderTitle: "", blurSystemName: false, value: $gradientBrightness, inValue: -1, outValue: 1, resetValue: 1)
                                
                                //MARK: Blur Slider
                                SliderView(systemName: "scribble.variable", sliderTitle: "", blurSystemName: true, value: $gradientBlur, inValue: 0, outValue: 100, resetValue: 0)
                                
                                //MARK: Scale Slider
                                SliderView(systemName: "arrow.up.left.and.arrow.down.right", sliderTitle: "", blurSystemName: false, value: $gradientScale, inValue: 0, outValue: 3.5, resetValue: 1)
                                
                                
                                //MARK: Rotation Slider
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.title2)
                                        .padding(.trailing)
                                    
                                    CustomSlider(value: $gradientRotation.degrees, inRange: 0...360, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    
                                    Text("\(Int(gradientRotation.degrees))°")
                                        .font(.footnote)
                                        .padding(.leading)
                                    
                                    AnimatedButton(action: {
                                        gradientRotation.degrees = 0
                                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                                    .padding(.leading, 8)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                
                                
                                //MARK: Chequered Slider
                                SliderView(systemName: "rectangle.checkered", sliderTitle: "", blurSystemName: false, value: $pixellate, inValue: 1, outValue: 75, resetValue: 1)
                                
                                //MARK: Wave effect Slider
                                HStack {
                                    Image(systemName: "water.waves")
                                        .font(.title2)
                                        .padding(.trailing)
                                    
                                    CustomSlider(value: $amplitude, inRange: 0...100, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    
                                    CustomSlider(value: $frequency, inRange: 0.001...200, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    
                                    AnimatedButton(action: {
                                        speed = 0
                                        amplitude = 5
                                        frequency = 200
                                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                                    .padding(.leading, 8)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                
                                //MARK: Add Half Blur Toggle
                                CustomToggle(showTitleText: true, titleText: "Show Half Blur", bindingValue: $showHalfBlur, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                                    .padding(.vertical, 8)
                                
                                //MARK: Color Picker
                                HStack {
                                    ForEach(0..<gradientColors.count, id: \.self) { index in
                                        if index < selectedColorCount {
                                            ColorPicker("", selection: $gradientColors[index])
                                                .onChange(of: gradientColors[index]) { color in
                                                    gradientColors[index] = color
                                                }
                                                .frame(width: 10)
                                                .padding(.horizontal, horizontalPadding)
                                        }
                                    }

                                    Divider()
                                        .padding(.leading, 8)
                                    
                                    ColorPicker("", selection: $bgColor,supportsOpacity: false)
                                        .frame(width: 10)
                                        .padding(.horizontal, horizontalPadding)
                                    
                                }
                                
                                //MARK: Re-Order Gradient Button
                                HStack {
                                    
                                    UltraThinButton(action: {
                                        showGradientControl = false
                                        
                                        generateGradient()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            
                                            showGradientControl = true
                                            
                                        }
                                    }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true)
                             
                                    Picker("Color Count", selection: $selectedColorCount) {
                                        ForEach(1...6, id: \.self) { count in
                                            Text("\(count)").tag(count)
                                        }
                                    }
                                    .tint(.primary)
                                }
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                .padding()
                        }
                    .padding(.bottom)
                .customPresentationWithBlur(detent: .medium, blurRadius: 0, backgroundColorOpacity: 1.0)
            }
        }
        .fullScreenCover(isPresented: $showBgPickerSheet) {
            createFullScreenCover(for: $importedBackground) { BgImage in
                importedBackground = BgImage.first
            }
        }
        .fullScreenCover(isPresented: $showImageOverlayPickerSheet) {
            createFullScreenCover(for: $importedImageOverlay) { overlayImage in
                importedImageOverlay = overlayImage.first
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showGradientControl = true
            }
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






