//
//  SettingsView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI
import SwiftUIKit

struct SettingsView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var obj: Object
    
    var body: some View {
        
        ScrollView {
            
            ButtonsAndPopoverView(viewModel: viewModel, obj: obj)
            
            VStack (spacing: -5){
                
                BackgroundSettingsView(viewModel: viewModel, obj: obj)
                
                MockupSettingsView(viewModel: viewModel, obj: obj)
                
                LogoSettingsView(viewModel: viewModel, obj: obj)
                
            }
            .customPresentationWithBlur(detent: .medium, blurRadius: 0, backgroundColorOpacity: 1.0)
        }
        .padding(.top, 30)
    }
}

struct ButtonsAndPopoverView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var obj: Object
    @State private var showPopover: Bool = false
    @State private var isTapped: Bool = false
    @State private var trashIsTapped: Bool = false
    
    var body: some View {
        HStack {
            AnimatedButton(action: {
                resetAppearance(obj)
            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
            .padding(.leading)
            
            Button {
                trashIsTapped.toggle()
                viewModel.importedBackground = nil
                viewModel.importedImage1 = nil
                viewModel.importedImage2 = nil
                viewModel.importedLogo = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    trashIsTapped.toggle()
                }
                
            } label: {
                Label("",systemImage: trashIsTapped ? "trash.circle.fill" : "trash.circle")
                    .font(.title2)
                    .padding(.leading)
                    .tint(Color(.systemRed))
            }
            .contentTransition(.symbolEffect(.replace))
            
            Spacer()
            
            Button {
                obj.appearance.easySettingsMode.toggle()
                isTapped.toggle()
            } label: {
                Label("",systemImage: obj.appearance.easySettingsMode ? "slider.horizontal.2.square" : "slider.horizontal.2.square.on.square")
                    .font(.title2)
                    .padding(.trailing)
            }
            .contentTransition(.symbolEffect(.replace))
            
            Button {
                isTapped.toggle()
                showPopover.toggle()
            } label: {
                Label("",systemImage: showPopover ? "xmark.circle": "info.circle")
                    .font(.title2)
                    .padding(.trailing)
            }
            .contentTransition(.symbolEffect(.replace))
            .popover(isPresented: $showPopover) {
                PopOverView()
            }
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .tint(.primary)
    }
    
    func resetAppearance(_ obj: Object) {
        
        // Reset Background parameters
        obj.appearance.backgroundOffsetY = 0
        obj.appearance.backgroundColour = .clear
        obj.appearance.backgroundColourOrGradient = false
        obj.appearance.blur = 0
        obj.appearance.hue = 0
        obj.appearance.saturation = 1
        obj.appearance.frameWidth = 510 * 2
        obj.appearance.frameHeight = 510 * 2
        obj.appearance.showBackground = true
        obj.appearance.wallBrightness = 0
        obj.appearance.wallContrast = 1
        obj.appearance.showGrid = false
        
        // Reset Mockup parameters
        obj.appearance.screenshotFitFill = false
        obj.appearance.selectedNotch = "None"
        obj.appearance.selectedScreenReflection = "None"
        obj.appearance.groundReflectionOffset = 0.0
        obj.appearance.showGroundReflection = false
        obj.appearance.scale = 1
        obj.appearance.colorMultiply = .white
        obj.appearance.screenReflectionOpacity = 0.5
        obj.appearance.offsetX = 0
        obj.appearance.offsetY = 0
        obj.appearance.rotate = 0
        obj.appearance.showShadow = false
        obj.appearance.shadowRadius = 10
        obj.appearance.shadowOpacity = 0.2
        obj.appearance.shadowOffsetX = 0
        obj.appearance.shadowOffsetY = 0
        obj.appearance.shadowColor = .black
        
        // Reset Logo parameters
        obj.appearance.showLogo = false
        obj.appearance.logoScale = 1
        obj.appearance.logoCornerRadius = 0
        obj.appearance.logoOffsetX = -360
        obj.appearance.logoOffsetY = 360
        obj.appearance.logoRotate = 0
    }
}

struct BackgroundSettingsView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var obj: Object
    
    @State private var showPopover_ShowBackground: Bool = false
    @State private var showPopover_AverageBackground: Bool = false
    @State private var showPopover_BackgroundColour: Bool = false
    @State private var showPopover_Blur: Bool = false
    @State private var showPopover_Hue: Bool = false
    @State private var showPopover_Saturation: Bool = false
    @State private var showPopover_FrameWidth: Bool = false
    @State private var showPopover_FrameHeight: Bool = false
    @State private var showPopover_BackgroundColourOrGradient: Bool = false
    @State private var showPopover_offset: Bool = false
    
    var body: some View {
        VStack {
            
            HStack (spacing: -5) {
                
                Text("Background Settings")
                    .font(.headline)
                    .padding()
                
                AnimatedButton(action: {
                    resetAppearance(obj)
                    
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 360, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                .scaleEffect(0.75)
                
                Spacer()
            }
            
            //Show Background
            HStack (spacing: -5) {
                
                Image(systemName: "photo")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_ShowBackground) {
                        Text("Toggles the background visibility so you can export the mockup as a transparent .png")
                    }
                
                
                CustomToggle(showTitleText: true, titleText: "Show Background", bindingValue: $obj.appearance.showBackground, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemRed))
            }
            .padding(.bottom, 5)
            
            //Show Grid
            HStack (spacing: -5) {
                Image(systemName: "grid")
                
                
                CustomToggle(showTitleText: true, titleText: "Show Alignment Grid", bindingValue: $obj.appearance.showGrid, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
            }
            .padding(.vertical, 10)
            .padding(.leading)
            
            
            if obj.appearance.showBackground {
                if !obj.appearance.easySettingsMode {
                    
                    //Background Colour Picker
                    HStack {
                        Image(systemName: "eyedropper.halffull")
                            .popOverInfo(isPresented: $showPopover_BackgroundColour) {
                                Text("Selects a background colour. You can also use the dropper to pick a colour from the mockup")
                            }
                        
                        Text("Background Colour")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        ColorPickerBar(
                            value: $obj.appearance.backgroundColour,
                            colors: .colorPickerBarColors(withClearColor: true),
                            config: .init(
                                addOpacityToPicker: true,
                                addResetButton: false,
                                resetButtonValue: nil
                            )
                        )
                        .padding(.leading)
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    
                    
                    HStack (spacing: -5) {
                        Image(systemName: "circle.bottomrighthalf.checkered")
                            .popOverInfo(isPresented: $showPopover_BackgroundColourOrGradient) {
                                Text("Background colour can either be a solid colour or a subtle gradient")
                            }
                        
                        CustomToggle(showTitleText: true, titleText: "Background Style" + "\(obj.appearance.backgroundColourOrGradient ? " :SOLID" : " :GRADIENT")", bindingValue: $obj.appearance.backgroundColourOrGradient, bindingValue2: nil, onSymbol: "circle.fill", offSymbol: "circle.bottomrighthalf.checkered", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                    }
                    .padding(.vertical, 10)
                    .padding(.leading)
                }
                
                // Blur
                SliderView(systemName: "scribble.variable", sliderTitle: "Blur", blurSystemName: true, value: $obj.appearance.blur, inValue: -0, outValue: 220, resetValue: 0)
                
                if !obj.appearance.easySettingsMode {
                    
                    Group {
                        if !obj.appearance.easySettingsMode {
                            // Hue
                            SliderView(systemName: "camera.filters", sliderTitle: "Hue", blurSystemName: false, value: $obj.appearance.hue, inValue: -180, outValue: 180, resetValue: 0)
                              
                            //Saturation
                            SliderView(systemName: "drop.halffull", sliderTitle: "Saturation", blurSystemName: false, value: $obj.appearance.saturation, inValue: 0, outValue: 5, resetValue: 1)
                            
                            //Contrast
                            SliderView(systemName: "circle.lefthalf.striped.horizontal", sliderTitle: "Contrast", blurSystemName: false, value: $obj.appearance.wallContrast, inValue: 0, outValue: 2, resetValue: 1)
                            
                            //Brightness
                            SliderView(systemName: "sun.max", sliderTitle: "Brightness", blurSystemName: false, value: $obj.appearance.wallBrightness, inValue: -1, outValue: 1, resetValue: 0)
                        }
                    }
                    .disabled(!obj.appearance.showBackground)
                    .opacity(obj.appearance.showBackground ? 1 : 0.5)
                    
                    //Background Offset Y
                    SliderView(systemName: "arrow.up.arrow.down", sliderTitle: "Offset", blurSystemName: false, value: $obj.appearance.backgroundOffsetY, inValue: -510, outValue: 510, resetValue: 0)
                        .disabled(viewModel.importedBackground == nil)
                        .opacity(viewModel.importedBackground == nil ? 0.5 : 1)
                }
                
                // Frame Width Size
                SliderView(systemName: "arrow.left.and.right.square", sliderTitle: "Frame Width", blurSystemName: false, value: $obj.appearance.frameWidth, inValue: 300, outValue: 1020, resetValue: 1020)
                
                // Frame Height Size
                SliderView(systemName: "arrow.up.and.down.square", sliderTitle: "Frame Height", blurSystemName: false, value: $obj.appearance.frameHeight, inValue: 800, outValue: 1020, resetValue: 1020)
                
            }
            
            Divider()
                .padding()
        }
    }
    func resetAppearance(_ obj: Object) {
        // Reset Background parameters
        obj.appearance.backgroundColour = .clear
        obj.appearance.backgroundColourOrGradient = false
        obj.appearance.blur = 0
        obj.appearance.hue = 0
        obj.appearance.saturation = 1
        obj.appearance.backgroundOffsetY = 0
        obj.appearance.frameWidth = 510 * 2
        obj.appearance.frameHeight = 510 * 2
        obj.appearance.wallBrightness = 0
        obj.appearance.wallContrast = 1
        obj.appearance.showGrid = false
    }
}

struct MockupSettingsView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var obj: Object
    
    @State private var showPopover_AspectRatio: Bool = false
    @State private var showPopover_NotchStyle: Bool = false
    @State private var showPopover_ScreenReflection: Bool = false
    @State private var showPopover_GroundReflection: Bool = false
    @State private var showPopover_Scale: Bool = false
    @State private var showPopover_ColorMultiply: Bool = false
    @State private var showPopover_OffsetX: Bool = false
    @State private var showPopover_Rotation: Bool = false
    @State private var showPopover_ShowShadow: Bool = false
    @State private var showPopover_ShadowRadius: Bool = false
    @State private var showPopover_ShadowOpacity: Bool = false
    @State private var showPopover_ShadowOffsetX: Bool = false
    @State private var showPopover_ShadowOffsetY: Bool = false
    @State private var showPopover_ScreenReflectionOpacity: Bool = false
    @State private var showPopover_ShadowColor: Bool = false
    
    var body: some View {
      VStack {
          
            HStack (spacing: -5) {
                
                Text("Mockup Settings")
                    .font(.headline)
                    .padding()
                
                AnimatedButton(action: {
                    resetAppearance(obj)
                    
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 360, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                .scaleEffect(0.75)
                
                Spacer()
                
            }
            
            
            // Aspect Ratio Toggle
            if !obj.appearance.easySettingsMode {
                HStack (spacing: -5) {
                    
                    Image(systemName: "arrow.up.right.and.arrow.down.left.square")
                        .padding(.leading)
                        .popOverInfo(isPresented: $showPopover_AspectRatio) {
                            Text("Adjusts aspect ratio content mode to fit or fill the frame")
                        }
                    
                    CustomToggle(showTitleText: true, titleText: "Aspect Ratio - Fit or Fill", bindingValue: $obj.appearance.screenshotFitFill, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                }
                .padding(.bottom, 10)
                
            }
            
            // Notch Picker
            HStack (spacing: -5) {
                
                Image(systemName: "platter.filled.top.and.arrow.up.iphone")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_NotchStyle) {
                        Text("Choose a notch style based on your device")
                    }
                
                Text("Notch Style")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .padding(.leading)
                
                Spacer()
                
                Picker("Notch", selection: $obj.appearance.selectedNotch) {
                    ForEach(obj.appearance.notchOptions, id: \.self) {
                        Text($0)
                    }
                }
                
            }
            .padding(.bottom, 10)
            
            // Reflecion Picker
            HStack (spacing: -5) {
                
                Image(systemName: "square.on.square")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_ScreenReflection) {
                        Text("Choose a screen reflection style to give an enhanced glass effect")
                    }
                
                Text("Screen Reflection Style")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .padding(.leading)
                
                Spacer()
                
                Picker("Reflection", selection: $obj.appearance.selectedScreenReflection) {
                    ForEach(obj.appearance.screenReflectionOptions, id: \.self) {
                        Text($0)
                    }
                }
                
            }
            
            // Reflection Opacity
            SliderView(systemName: "circle.dotted.and.circle", sliderTitle: "Reflection Opacity", blurSystemName: false, value: $obj.appearance.screenReflectionOpacity, inValue: 0.1, outValue: 1, resetValue: 1)
            
            // Ground Refletion Toggle
            HStack (spacing: -5) {
                
                Image(systemName: "square.bottomhalf.filled")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_GroundReflection) {
                        Text("Toggle a ground reflection on and off. Note: Not for all mockups")
                    }
                
                CustomToggle(showTitleText: true, titleText: "Show Ground Reflection", bindingValue: $obj.appearance.showGroundReflection, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
            }
            .padding(.vertical, 5)
            
            // Reflection Offset
            SliderView(systemName: "arrow.up.arrow.down", sliderTitle: "Reflection Offset", blurSystemName: false, value: $obj.appearance.groundReflectionOffset, inValue: 0, outValue: 75, resetValue: 0)
            
            
            if !obj.appearance.easySettingsMode {
                
                SliderView(systemName: "arrow.down.left.and.arrow.up.right", sliderTitle: "Scale", blurSystemName: false, value: $obj.appearance.scale, inValue: 0.5, outValue: 3, resetValue: 1)
                
                // Color multiply picker
                HStack {
                    Image(systemName: "drop.halffull")
                        .popOverInfo(isPresented: $showPopover_ColorMultiply) {
                            Text("Add an overlay colour on the frame. Apply a transparent black overlay to make the frame invisible.")
                        }
                    
                    Text("Colour Multiply")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    ColorPickerBar(
                        value: $obj.appearance.colorMultiply,
                        colors: .colorPickerBarColors(withClearColor: true),
                        config: .init(
                            addOpacityToPicker: true,
                            addResetButton: false,
                            resetButtonValue: nil
                        )
                    )
                    .padding(.leading)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                // Horizontal Offset
                SliderView(systemName: "arrow.left.arrow.right", sliderTitle: "Offset", blurSystemName: false, value: $obj.appearance.offsetX, inValue: -500, outValue: 500, resetValue: 0)
                
                // Vertical Offset
                SliderView(systemName: "arrow.up.arrow.down", sliderTitle: "Offset", blurSystemName: false, value: $obj.appearance.offsetY, inValue: -500, outValue: 500, resetValue: 0)
                
                // Rotation
                SliderView(systemName: "arrow.circlepath", sliderTitle: "Rotation", blurSystemName: false, value: $obj.appearance.rotate, inValue: -180, outValue: 180, resetValue: 0)
                
                // Shadow Colour Picker
                HStack {
                    Image(systemName: "drop.halffull")
                        .popOverInfo(isPresented: $showPopover_ShadowColor) {
                            Text("Select the colour of the shadow effect")
                        }
                    
                    Text("Shadow Colour")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    ColorPickerBar(
                        value: $obj.appearance.shadowColor,
                        colors: .colorPickerBarColors(withClearColor: true),
                        config: .init(
                            addOpacityToPicker: true,
                            addResetButton: false,
                            resetButtonValue: nil
                        )
                    )
                    .padding(.leading)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Shadow Opacity
                SliderView(systemName: "circle.dotted.and.circle", sliderTitle: "Shadow Opacity", blurSystemName: false, value: $obj.appearance.shadowOpacity, inValue: 0, outValue: 1, resetValue: 0.0)
                
                // Shadow Radius
                SliderView(systemName: "scribble.variable", sliderTitle: "Shadow Blur", blurSystemName: true, value: $obj.appearance.shadowRadius, inValue: 0, outValue: 100, resetValue: 0)
                
                // Shadow Offsey X
                SliderView(systemName: "arrow.left.arrow.right", sliderTitle: "Shadow Offset", blurSystemName: false, value: $obj.appearance.shadowOffsetX, inValue: -300, outValue: 300, resetValue: 0)
                
                // Shadow Offsey Y
                SliderView(systemName: "arrow.up.arrow.down", sliderTitle: "Shadow Offset", blurSystemName: false, value: $obj.appearance.shadowOffsetY, inValue: -300, outValue: 300, resetValue: 0)
                
            }
        }
        
        Divider()
            .padding()
    }
    func resetAppearance(_ obj: Object) {
        
        // Reset Mockup parameters
        obj.appearance.screenshotFitFill = false
        obj.appearance.selectedNotch = "None"
        obj.appearance.selectedScreenReflection = "None"
        obj.appearance.screenReflectionOpacity = 0.5
        obj.appearance.showGroundReflection = false
        obj.appearance.scale = 1
        obj.appearance.colorMultiply = .white
        obj.appearance.offsetX = 0
        obj.appearance.offsetY = 0
        obj.appearance.rotate = 0
        obj.appearance.showShadow = false
        obj.appearance.shadowRadius = 10
        obj.appearance.shadowOpacity = 0.2
        obj.appearance.shadowOffsetX = 0
        obj.appearance.shadowOffsetY = 0
        obj.appearance.shadowColor = .black
    }
}

struct LogoSettingsView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var obj: Object
    
    @State private var showPopover_ShowLogo: Bool = false
    @State private var showPopover_LogoScale: Bool = false
    @State private var showPopover_LogoCornerRadius: Bool = false
    @State private var showPopover_LogoOffsetX: Bool = false
    @State private var showPopover_LogoOffsetY: Bool = false
    @State private var showPopover_LogoRotation: Bool = false
    
    
    var body: some View {
        VStack {
            HStack (spacing: -5) {
                
                Text("Logo Settings")
                    .font(.headline)
                    .padding()
                
                AnimatedButton(action: {
                    resetAppearance(obj)
                    
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 360, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                .scaleEffect(0.75)
                
                Spacer()
                
            }
            
            HStack (spacing: -5) {
                
                Image(systemName: "person.circle")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_ShowLogo) {
                        Text("Toggles the logo visibility")
                    }
                
                
                CustomToggle(showTitleText: true, titleText: "Show Logo", bindingValue: $obj.appearance.showLogo, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemRed))
            }
            .padding(.bottom, 10)
            
            if obj.appearance.showLogo {
                Group {
             
                    // Logo Scale
                    SliderView(systemName: "arrow.down.left.and.arrow.up.right", sliderTitle: "Scale", blurSystemName: false, value: $obj.appearance.logoScale, inValue: 0.5, outValue: 3, resetValue: 1)
             
                    // Logo Corner Radius
                    SliderView(systemName: "square.on.circle", sliderTitle: "Corner Radius", blurSystemName: false, value: $obj.appearance.logoCornerRadius, inValue: 0, outValue: 100, resetValue: 0)
                    
                   
                    
                    if !obj.appearance.easySettingsMode {
                        
                        // Logo Offset X
                        SliderView(systemName: "arrow.left.arrow.right", sliderTitle: "Logo Offset", blurSystemName: false, value: $obj.appearance.logoOffsetX, inValue: -360, outValue: 360, resetValue: -360)
                        
                        // Logo Offset X
                        SliderView(systemName: "arrow.up.arrow.down", sliderTitle: "Logo Offset", blurSystemName: false, value: $obj.appearance.logoOffsetY, inValue: -360, outValue: 360, resetValue: 360)
                    
                        // Logo Offset X
                        SliderView(systemName: "arrow.circlepath", sliderTitle: "Rotation", blurSystemName: false, value: $obj.appearance.logoRotate, inValue: -180, outValue: 180, resetValue: 0)
                   
                    }
                }
                .disabled(viewModel.importedLogo == nil)
                .opacity(viewModel.importedLogo == nil ? 0.5 : 1)
            }
        }
        
        Divider()
            .padding()
    }
    func resetAppearance(_ obj: Object) {
        // Reset Logo parameters
        obj.appearance.logoScale = 1
        obj.appearance.logoCornerRadius = 0
        obj.appearance.logoOffsetX = -360
        obj.appearance.logoOffsetY = 360
        obj.appearance.logoRotate = 0
    }
}

struct ScalePercentageText: View {
    let scale: CGFloat
    let maxScale: CGFloat
    let fontSize: CGFloat
    
    var body: some View {
        
        
        Text("\(abs(scale / maxScale * 100.0), specifier: "%.0f")%")
            .font(.system(size: fontSize))
            .frame(width: 40)
    }
}


extension View {
    func popOverInfo<Content: View>(isPresented: Binding<Bool>, onTapAction: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .onLongPressGesture (minimumDuration: 0.2) {
                feedback()
                onTapAction?()
                isPresented.wrappedValue.toggle()
            }
            .alwaysPopover(isPresented: isPresented) {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "info.circle")
                            
                            content()
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                        }
                        .frame(height: 40)
                        .font(.footnote)
                        Spacer()
                    }
                    
                }
                
                .padding(10)
            }
        
    }
}

struct CustomSliderView: View {
    
    @StateObject var obj: Object
    let imageSystemName: String
    let popOverBinding: Binding<Bool>
    let popOverText: String
    let toggleTitle: String
    let sliderObjectBinding: Binding<CGFloat>
    let sliderObject: CGFloat
    let sliderObjectMaxScale: CGFloat
    let sliderObjectMaxScaleDivider: CGFloat
    let sliderRange: ClosedRange<CGFloat>
    let usePercentageLable: Bool
    
    
    
    var body: some View {
        HStack {
            Image(systemName: imageSystemName)
                .popOverInfo(isPresented: popOverBinding) {
                    Text(popOverText)
                }
            
            Text(toggleTitle)
                .font(.system(size: obj.appearance.settingsSliderFontSize))
            
            CustomSlider(value: sliderObjectBinding, inRange: sliderRange, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
            }
            .padding(.trailing, 10)
            
            if !usePercentageLable {
                Text("\(abs(sliderObjectBinding.wrappedValue), specifier: "%.0f")°")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .frame(width: 40)
            } else {
                ScalePercentageText(scale: sliderObject, maxScale: sliderObjectMaxScale / sliderObjectMaxScaleDivider, fontSize: obj.appearance.settingsSliderFontSize)
            }
        }
        .padding()
    }
}


struct PopOverView: View {
    var body: some View {
        VStack {
            HStack {
                Text("\(Image(systemName: "info.circle")) Info")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            List {
                Text("\(Image(systemName: "iphone.gen2.circle")) Single tap: Import screenshot image")
                Text("\(Image(systemName: "photo.circle")) Import background image")
                Text("\(Image(systemName: "person.circle")) Import logo overlay image")
                Text("\(Image(systemName: "arrow.counterclockwise.circle")) Reset sliders and toggles to default settings")
                Text("\(Image(systemName: "trash.circle")) Remove all imported images")
                Text("\(Image(systemName: "ellipsis.circle")) Drag on the page indicator to move between mockups faster")
                Text("\(Image(systemName: "hand.draw")) Drag up on the screen to show settings instead of tapping the settings gear")
                Text("\(Image(systemName: "square.and.arrow.up.circle.fill")) Long press the save/share icon to toggle save behaviour")
                Text("\(Image(systemName: "slider.horizontal.2.square.on.square")) Tap to toggle between simple or advanced settings")
            }
            .font(.footnote)
            .listStyle(.plain)
        }
        .padding()
    }
}
