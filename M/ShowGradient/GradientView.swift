//
//  GradientView.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 12/06/2023.
//

import SwiftUI
import Photos

struct GradientView: View {
    
    // @StateObject var obj: Object
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
    
    enum GradientStyle: String, CaseIterable, Identifiable {
        case linear, radial, angular
        var id: String { self.rawValue }
    }
    
    init(isShowingGradientView: Binding<Bool>) {
        _isShowingGradientView = isShowingGradientView
        _gradientColors = State(initialValue: generateRandomColors(count: 6))
        isShowingGradientSavedNotification = false
    }
    
    @State private var gradientBlur: CGFloat = 0
    @State private var gradientScale: CGFloat = 1.0
    @State private var gradientRotation: Angle = .zero
    @State private var gradientOffsetX: CGFloat = 0
    @State private var gradientOffsetY: CGFloat = 0
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let sliderHeight: CGFloat = 10
    @State private var bgColor = (Color.black)
    @State private var showGradientControl: Bool = false
    let bottomPadding: CGFloat = 8
    let horizontalPadding: CGFloat = 10
    let scaleEffect: CGFloat = 0.75
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
    
    
    let startDate: Date = .init()
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    
    var body: some View {
        ZStack {
            ZStack {
                Group {
                    Rectangle()
                        .foregroundColor(bgColor)
                    
                    //MARK: This is the view I want to export as an image
                    GradientBackground(gradientColors: selectedColors(), refreshButtonTapped: $refreshButtonTapped, gradientStyle: gradientStyle, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, speed: $speed, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast)
                       // .scaleEffect(1.1)
                    
                    if blendMode != .normal {
                        GradientBackground(gradientColors: selectedColors(), refreshButtonTapped: $refreshButtonTapped, gradientStyle: gradientStyle, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientBlur: $gradientBlur, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, pixellate: $pixellate, speed: $speed, amplitude: $amplitude, frequency: $frequency, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast)
                            .blendMode(blendMode)
                          //  .scaleEffect(1.1)
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
                showGradientControl.toggle()
            }
            
            if !isSavingImage {
                //MARK: These are the buttons
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        //MARK: Drag Indicator
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 80, height: 5)
                            .foregroundColor(.white.opacity(0.2))
                            .padding(.top)
                        
                        ZStack {
                            
                            ScrollView {
                                
                                VStack {
                                    
                                    //MARK: Reset Button
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Button {
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
                                            
                                            
                                        } label: {
                                            
                                            Circle()
                                                .fill(.blue.opacity(0.5))
                                                .frame(width: 30, height: 30)
                                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                                .overlay {
                                                    Image(systemName: "arrow.counterclockwise")
                                                        .font(.system(.body, design: .rounded).weight(.medium))
                                                        .foregroundColor(.white)
                                                }
                                        }
                                    }
                                    .frame(width: sliderScale.width * 0.9)
                                    .scaleEffect(0.8)
                                    .tint(.white)
                                    .padding(.trailing)
                                    .padding(.bottom)
                                    
                                    //MARK: Horizontal and Vertical Position Sliders
                                    HStack{
                                        
                                        Image(systemName: "arrow.left.arrow.right")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                            .offset(y: 15)
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        VStack {
                                            
                                            Text("\(Int((gradientOffsetX / 1000) * 100))%")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                            
                                            Slider(value: $gradientOffsetX, in: -1000...1000)
                                                .frame(width: sliderScale.width * 0.28)
                                            
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.arrow.down")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                            .offset(y: 15)
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        VStack {  Text("\(Int((gradientOffsetY / 1000) * 100))%")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                            
                                            Slider(value: $gradientOffsetY, in: -1000...1000)
                                                .frame(width: sliderScale.width * 0.28)
                                        }
                                        
                                        Button {
                                            gradientOffsetX = 0
                                            gradientOffsetY = 0
                                        } label: {
                                            Image(systemName: "arrow.counterclockwise")
                                                .font(.system(.body, design: .rounded).weight(.medium))
                                                .foregroundColor(.white)
                                                .offset(y: 12)
                                                .padding(.leading)
                                                .padding(.leading)
                                        }
                                    }
                                    .frame(width: sliderScale.width)
                                    .scaleEffect(scaleEffect)
                                    .padding(.bottom, bottomPadding)
                                    
                                    //MARK: Hue Slider
                                    SliderView(systemName: "camera.filters", value: $gradientHue, inValue: -180, outValue: 180, resetValue: 0)

                                    //MARK: Sat Slider
                                    SliderView(systemName: "drop.halffull", value: $gradientSaturation, inValue: 0, outValue: 2, resetValue: 1)
                        
                                    //MARK: Contrast Slider
                                    SliderView(systemName: "circle.lefthalf.striped.horizontal", value: $gradientContrast, inValue: 0.1, outValue: 3, resetValue: 1)
                                                                       //MARK: Brightneass Slider
                                    SliderView(systemName: "sun.max", value: $gradientBrightness, inValue: -1, outValue: 1, resetValue: 1)
                                 
                                    //MARK: Blur Slider
                                    SliderView(systemName: "scribble.variable", value: $gradientBlur, inValue: 0, outValue: 40, resetValue: 0)
                                  
                                    //MARK: Scale Slider
                                    SliderView(systemName: "arrow.up.left.and.arrow.down.right", value: $gradientScale, inValue: 0, outValue: 3.5, resetValue: 1)
                                 
                                    
                                    //MARK: Rotation Slider
                                    HStack {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        
                                        Slider(value: $gradientRotation.degrees, in: 0...360)
                                        
                                        Text("\(Int(gradientRotation.degrees))°")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            .padding(.leading)
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        
                                        Button {
                                            gradientRotation.degrees = 0
                                        } label: {
                                            Image(systemName: "arrow.counterclockwise")
                                                .font(.system(.body, design: .rounded).weight(.medium))
                                                .foregroundColor(.white)
                                                .padding(.leading)
                                                .padding(.leading)
                                        }
                                    }
                                    .frame(width: sliderScale.width)
                                    .scaleEffect(scaleEffect)
                                    .padding(.bottom)
                                    
                                    //MARK: Chequered Slider
                                    SliderView(systemName: "rectangle.checkered", value: $pixellate, inValue: 1, outValue: 75, resetValue: 1)
                                  
                                    //MARK: Wave effect Slider
                                    HStack {
                                        Image(systemName: "water.waves")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        
                                        Slider(value: $speed, in: 0...1)
                                        
                                        Slider(value: $amplitude, in: 0...100)
                                        
                                        Slider(value: $frequency, in: 1...200)
                                        
                                        Button {
                                            speed = 0
                                            amplitude = 5
                                            frequency = 200
                                        } label: {
                                            Image(systemName: "arrow.counterclockwise")
                                                .font(.system(.body, design: .rounded).weight(.medium))
                                                .foregroundColor(.white)
                                                .padding(.leading)
                                                .padding(.leading)
                                        }
                                        
                                    }
                                    .frame(width: sliderScale.width)
                                    .scaleEffect(scaleEffect)
                                    .padding(.bottom, 10)
                                    
                                    //MARK: Add Half Blur Toggle
                                    HStack {
                                        
                                        Toggle(isOn: $showHalfBlur, label: {
                                            Text("Show Half Blur")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        })
                                    }
                                    .frame(width: sliderScale.width)
                                    .scaleEffect(scaleEffect)
                                    .padding(.bottom)
                                    
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
                                        
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 10)
                                            .padding(.leading, 10)
                                        
                                        ColorPicker("", selection: $bgColor,supportsOpacity: false)
                                            .frame(width: 10)
                                            .padding(.horizontal, horizontalPadding)
                                        
                                    }
                                    
                                    //MARK: Re-Order Gradient Button
                                    HStack {
                                        
                                        Button(action: {
                                            
                                            showGradientControl = false
                                            
                                            generateGradient()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                
                                                showGradientControl = true
                                                
                                            }
                                            
                                            
                                            
                                        }) {
                                            Text("ReOrder Gradient")
                                                .font(.footnote)
                                                .padding()
                                                .foregroundColor(.white)
                                                .padding(.vertical, -5)
                                                .background(Color.black.opacity(0.3))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
                                        }
                                        
                                        Picker("Color Count", selection: $selectedColorCount) {
                                            ForEach(1...6, id: \.self) { count in
                                                Text("\(count)").tag(count)
                                            }
                                        }
                                        .tint(.white)
                                    }
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                }
                                .padding()
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                        
                        .frame(width: screenWidth)
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .offset(y: showGradientControl ? 0 : UIScreen.main.bounds.height)
                .animation(.easeInOut, value: showGradientControl)
                .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .global)
                    .onEnded { value in
                        if value.translation.height > 0 {
                            showGradientControl = false
                        }
                    })
                
                VStack {
                    HStack {
                        
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
                        
                        Button{
                            showBgPickerSheet.toggle()
                        } label: {
                            Circle()
                                .fill(.blue.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "photo.circle.fill")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .foregroundColor(.white)
                                }
                        }
                        .shadow(radius: 3)
                        .padding(.trailing)
                        .padding(.top, 10)
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            showImageOverlayPickerSheet.toggle()
                        } label: {
                            Circle()
                                .fill(.blue.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "photo.circle")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .foregroundColor(.white)
                                }
                        }
                        .shadow(radius: 3)
                        .padding(.trailing)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.horizontal)
                .font(.footnote)
                .tint(.white)
            }
        }
        .ignoresSafeArea()
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

// View showing gradient
struct GradientBackground: View {
    let gradientColors: [Color]
    @Binding var refreshButtonTapped: Bool
    let gradientStyle: GradientView.GradientStyle
    
    @State private var animationDuration: Double = 0.5
    @State private var center: UnitPoint = .zero
    @State private var startRadius: CGFloat = 0.0
    @State private var endRadius: CGFloat = 0.0
    @State private var startAngle: Angle = .zero
    @State private var endAngle: Angle = .zero
    @State private var startPoint: UnitPoint = .topLeading
    @State private var endPoint: UnitPoint = .bottomTrailing
    @Binding var gradientScale: CGFloat
    @Binding var gradientRotation: Angle
    @Binding var gradientBlur: CGFloat
    @Binding var gradientOffsetX: CGFloat
    @Binding var gradientOffsetY: CGFloat
    @Binding var importedBackground: UIImage?
    
    @Binding var pixellate: CGFloat
    @Binding var speed: CGFloat
    @Binding var amplitude: CGFloat
    @Binding var frequency: CGFloat
    
    let startDate: Date = .init()
    
    @Binding var gradientHue: CGFloat
    @Binding var gradientSaturation: CGFloat
    @Binding var gradientBrightness: CGFloat
    @Binding var gradientContrast: CGFloat
    
    var body: some View {
        let gradient: AnyView
        switch gradientStyle {
        case .linear:
            gradient = AnyView(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: startPoint, endPoint: endPoint)
            )
        case .radial:
            gradient = AnyView(
                RadialGradient(gradient: Gradient(colors: gradientColors), center: center, startRadius: startRadius, endRadius: endRadius)
            )
        case .angular:
            gradient = AnyView(
                AngularGradient(gradient: Gradient(colors: gradientColors), center: center, startAngle: startAngle, endAngle: endAngle)
            )
        }
        
        return Group {
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                ZStack {
                    gradient.animation(.linear(duration: animationDuration))
                    
                    if let background = importedBackground {
                        Image(uiImage: background)
                            .resizable()
                    }
                }
                .distortionEffect(
                    .init(
                        function: .init(library: .default, name: "wave"),
                        arguments: [
                            .float(time),
                            .float(speed),
                            .float(frequency),
                            .float(amplitude)
                        ]
                    ),
                    maxSampleOffset: .zero
                )
            }
        }
        .id(refreshButtonTapped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hueRotation(Angle(degrees: gradientHue))
        .saturation(gradientSaturation)
        .contrast(gradientContrast)
        .brightness(gradientBrightness)
        .scaleEffect(gradientScale)
        //   .blur(radius: gradientBlur)
        .rotationEffect(gradientRotation)
        .offset(x: gradientOffsetX, y: gradientOffsetY)
        .clipShape(Rectangle())
        .distortionEffect(
            .init(
                function: .init(library: .default, name: "pixellate"),
                arguments: [.float(pixellate)]
            ),
            maxSampleOffset: .zero
        )
        .onAppear {
            animationDuration = 1.0
            updateGradientProperties()
        }
        .onChange(of: refreshButtonTapped) {
            updateGradientProperties()
        }
    }
    
    private func updateGradientProperties() {
        center = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
        startRadius = CGFloat.random(in: 0...500)
        endRadius = CGFloat.random(in: startRadius...1000)
        startAngle = Angle(degrees: Double.random(in: 0...360))
        endAngle = Angle(degrees: Double.random(in: startAngle.degrees...startAngle.degrees + 360))
        startPoint = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
        endPoint = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
    }
}

struct SliderView: View {
    let bottomPadding: CGFloat = 8
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let scaleEffect: CGFloat = 0.75
    
    let systemName: String
    @Binding var value: CGFloat
    let inValue: CGFloat
    let outValue: CGFloat
    let resetValue: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.trailing)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
            
            Slider(value: $value, in: inValue...outValue)
            
            Text("\(Int(value))")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.leading)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0)
            
            Button {
                value = resetValue
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundColor(.white)
                    .padding(.leading)
            }
        }
        .frame(width: sliderScale.width)
        .scaleEffect(scaleEffect)
        .padding(.bottom, bottomPadding)
    }
}


