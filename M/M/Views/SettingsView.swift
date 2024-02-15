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
            .alwaysPopover(isPresented: $showPopover) {
                
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
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .padding()
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
    @State private var showPopover_BackgroundColourOrGradient: Bool = false
    @State private var showPopover_offset: Bool = false
    
    var body: some View {
        Group {
            
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
                            Image(systemName: "circle.lefthalf.striped.horizontal")
                                .popOverInfo(isPresented: $showPopover_BackgroundColourOrGradient) {
                                    Text("Background colour can either be a solid colour or a subtle gradient")
                                }
                            
                            CustomToggle(showTitleText: true, titleText: "Background Style" + "\(obj.appearance.backgroundColourOrGradient ? " :SOLID" : " :GRADIENT")", bindingValue: $obj.appearance.backgroundColourOrGradient, bindingValue2: nil, onSymbol: "circle.righthalf.filled.inverse", offSymbol: "circle.lefthalf.striped.horizontal", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                        }
                        .padding(.vertical, 10)
                        .padding(.leading)
                    }
                    
                    // Blur
                    HStack {
                        Image(systemName: "scribble.variable")
                            .popOverInfo(isPresented: $showPopover_Blur) {
                                Text("Blurs the imported background")
                            }
                        
                        Text("Blur")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        CustomSlider(value: $obj.appearance.blur, inRange: 0...200, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        }
                        .padding(.trailing, 10)
                        
                        ScalePercentageText(scale: obj.appearance.blur, maxScale: 100 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                    }
                    .padding()
                    
                    if !obj.appearance.easySettingsMode {
                       
                        Group {
                            if !obj.appearance.easySettingsMode {
                                // Hue
                                HStack {
                                    Image(systemName: "camera.filters")
                                        .popOverInfo(isPresented: $showPopover_Hue) {
                                            Text("Adjusts the Hue rotation of the background")
                                        }
                                    
                                    Text("Hue")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                                    
                                    CustomSlider(value: $obj.appearance.hue, inRange: -180...180, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    .padding(.trailing, 10)
                                    
                                    Text("\(abs(obj.appearance.hue), specifier: "%.0f")°")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                                        .frame(width: 40)
                                }
                                .padding()
                                
                                //Saturation
                                HStack {
                                    Image(systemName: "drop.halffull")
                                        .popOverInfo(isPresented: $showPopover_Saturation) {
                                            Text("Adjusts the saturation of the background")
                                        }
                                    
                                    Text("Saturation")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                                    
                                    CustomSlider(value: $obj.appearance.saturation, inRange: 0...2, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    .padding(.trailing, 10)
                                    
                                    ScalePercentageText(scale: obj.appearance.saturation, maxScale: 1, fontSize: obj.appearance.settingsSliderFontSize)
                                }
                                .padding()
                                
                                HStack {
                                    Image(systemName: "circle.lefthalf.striped.horizontal")
                                        .popOverInfo(isPresented: $showPopover_Saturation) {
                                            Text("Adjusts the contrast of the background")
                                        }
                                    
                                    Text("Contrast")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                                    
                                    CustomSlider(value: $obj.appearance.wallContrast, inRange: 0...2, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    .padding(.trailing, 10)
                                    
                                    ScalePercentageText(scale: obj.appearance.wallContrast, maxScale: 1, fontSize: obj.appearance.settingsSliderFontSize)
                                }
                                .padding()
                                
                                HStack {
                                    Image(systemName: "sun.max")
                                        .popOverInfo(isPresented: $showPopover_Saturation) {
                                            Text("Adjusts the brightness of the background")
                                        }
                                    
                                    Text("Brightness")
                                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                                    
                                    CustomSlider(value: $obj.appearance.wallBrightness, inRange: -1...1, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                                    }
                                    .padding(.trailing, 10)
                                    
                                    ScalePercentageText(scale: obj.appearance.wallBrightness, maxScale: 1, fontSize: obj.appearance.settingsSliderFontSize)
                                }
                                .padding()
                            }
                        }
                        .disabled(!obj.appearance.showBackground)
                        .opacity(obj.appearance.showBackground ? 1 : 0.5)
                        
                        //Background Offset Y
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                                .popOverInfo(isPresented: $showPopover_offset) {
                                    Text("Offset the background vertically")
                                }
                            
                            Text("Offset")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            
                            CustomSlider(value: $obj.appearance.backgroundOffsetY, inRange: -300...300, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            }
                            .padding(.trailing, 10)
                            
                            ScalePercentageText(scale: obj.appearance.backgroundOffsetY, maxScale: 300 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                        }
                        .padding()
                        .disabled(viewModel.importedBackground == nil)
                        .opacity(viewModel.importedBackground == nil ? 0.5 : 1)
                    }
                    
                    // Frame Size
                    HStack {
                        Image(systemName: "square.resize")
                            .popOverInfo(isPresented: $showPopover_FrameWidth) {
                                Text("Adjusts the frame width of the background")
                            }
                        
                        Text("Frame Width")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        CustomSlider(value: $obj.appearance.frameWidth, inRange: 300...1020, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        }
                        .padding(.trailing, 10)
                        
                        ScalePercentageText(scale: obj.appearance.frameWidth, maxScale: 510 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                        
                    }
                    .padding()
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
        Group {
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
            
            
            // Aspect Ratio
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
            
            HStack {
                Image(systemName: "circle.bottomrighthalf.checkered")
                    .popOverInfo(isPresented: $showPopover_ScreenReflectionOpacity) {
                        Text("Adjust the opacity of the screen reflection from 20% to 100%")
                    }
                
                Text("Screen Opacity")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                
                CustomSlider(value: $obj.appearance.screenReflectionOpacity, inRange: 0.2...1, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                }
                .padding(.trailing, 10)
                
                ScalePercentageText(scale: obj.appearance.screenReflectionOpacity, maxScale: 1, fontSize: obj.appearance.settingsSliderFontSize)
                
            }
            .padding()
            
            HStack (spacing: -5) {
                
                Image(systemName: "square.bottomhalf.filled")
                    .padding(.leading)
                    .popOverInfo(isPresented: $showPopover_GroundReflection) {
                        Text("Toggle a ground reflection on and off. Note: Not for all mockups")
                    }
                
                CustomToggle(showTitleText: true, titleText: "Show Ground Reflection", bindingValue: $obj.appearance.showGroundReflection, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
            }
            .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                   
                Text("Reflection Offset")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                
                CustomSlider(value: $obj.appearance.groundReflectionOffset, inRange: 0...75, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                }
                .padding(.trailing, 10)
                
                ScalePercentageText(scale: obj.appearance.groundReflectionOffset, maxScale: 75, fontSize: obj.appearance.settingsSliderFontSize)
                
            }
            .padding()
            
            if !obj.appearance.easySettingsMode {
                
                HStack {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .popOverInfo(isPresented: $showPopover_Scale) {
                            Text("Adjust the scale of the mockup")
                        }
                    
                    Text("Scale")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.scale, inRange: 0.5...3.0, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.scale, maxScale: 3, fontSize: obj.appearance.settingsSliderFontSize)
                    
                }
                .padding()
                 
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
                
                
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                        .popOverInfo(isPresented: $showPopover_OffsetX) {
                            Text("Move the mockup left and right")
                        }
                    
                    Text("Offset")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.offsetX, inRange: -500...500, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.offsetX, maxScale: 500 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                    
                }
                .padding()
                 
                
                
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .popOverInfo(isPresented: $showPopover_OffsetX) {
                            Text("Move the mockup up and down")
                        }
                    
                    Text("Offset")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.offsetY, inRange: -500...500, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.offsetY, maxScale: 500 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                }
                .padding()
                 
                
                
                 HStack {
                 Image(systemName: "arrow.circlepath")
                 .popOverInfo(isPresented: $showPopover_Rotation) {
                 Text("Rotate the mockup")
                 }
                 
                 Text("Rotation")
                 .font(.system(size: obj.appearance.settingsSliderFontSize))
                 
                 CustomSlider(value: $obj.appearance.rotate, inRange: -180...180, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                 }
                 .padding(.trailing, 10)
                 
                 
                 Text("\(abs(obj.appearance.rotate), specifier: "%.0f")°")
                 .font(.system(size: obj.appearance.settingsSliderFontSize))
                 .frame(width: 40)
                 }
                 .padding()
                 
                
                HStack (spacing: -5) {
                    
                    Image(systemName: "square.filled.on.square")
                        .padding(.leading)
                        .popOverInfo(isPresented: $showPopover_ShowShadow) {
                            Text("Toggle on and off the shadow effect")
                        }
                    
                    CustomToggle(showTitleText: true, titleText: "Show Shadow", bindingValue: $obj.appearance.showShadow, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                }
                .padding(.vertical, 10)
                
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
                
                
                HStack {
                    Image(systemName: "rectangle.expand.vertical")
                        .popOverInfo(isPresented: $showPopover_ShadowRadius) {
                            Text("Increase or decreses the shadow radius")
                        }
                    
                    Text("Shadow Radius")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.shadowRadius, inRange: 5...100, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.shadowRadius, maxScale: 100, fontSize: obj.appearance.settingsSliderFontSize)
                }
                .padding()
                 
                
               
                
                HStack {
                    Image(systemName: "circle.bottomrighthalf.checkered")
                        .popOverInfo(isPresented: $showPopover_ShadowOpacity) {
                            Text("Increase or decrease the shadow opacity")
                        }
                    
                    Text("Shadow Opacity")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.shadowOpacity, inRange: 0.1...1, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.shadowOpacity, maxScale: 1, fontSize: obj.appearance.settingsSliderFontSize)
                }
                .padding()
                 
                
                
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                        .popOverInfo(isPresented: $showPopover_ShadowOffsetX) {
                            Text("Move the shadow effect left and right")
                        }
                    
                    Text("Shadow Offset")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.shadowOffsetX, inRange: -300...300, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.shadowOffsetX, maxScale: 300 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                }
                .padding()
                 
                
                
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .popOverInfo(isPresented: $showPopover_ShadowOffsetY) {
                            Text("Move the shadow effect up and down")
                        }
                    
                    Text("Shadow Offset")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    CustomSlider(value: $obj.appearance.shadowOffsetY, inRange: -300...300, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    }
                    .padding(.trailing, 10)
                    
                    ScalePercentageText(scale: obj.appearance.shadowOffsetY, maxScale: 300 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                }
                .padding()
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
        Group {
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
                    HStack {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .popOverInfo(isPresented: $showPopover_LogoScale) {
                                Text("Adjust the imported logo scale")
                            }
                        
                        Text("Scale")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        
                        CustomSlider(value: $obj.appearance.logoScale, inRange: 0.5...3, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        }
                        .padding(.trailing, 10)
                        
                        ScalePercentageText(scale: obj.appearance.logoScale, maxScale: 3, fontSize: obj.appearance.settingsSliderFontSize)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "square.on.circle")
                            .popOverInfo(isPresented: $showPopover_LogoCornerRadius) {
                                Text("Adjust the imported logo corner radius")
                            }
                        
                        Text("Corner radius")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        CustomSlider(value: $obj.appearance.logoCornerRadius, inRange: 0...100, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        }
                        .padding(.trailing, 10)
                        
                        Text("\(obj.appearance.logoCornerRadius, specifier: "%.1f")")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .frame(width: 40)
                    }
                    .padding()
                    
                    if !obj.appearance.easySettingsMode {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .popOverInfo(isPresented: $showPopover_LogoOffsetX) {
                                    Text("Move the imported logo left or right")
                                }
                            
                            Text("Logo Offset")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            
                            CustomSlider(value: $obj.appearance.logoOffsetX, inRange: -360...360, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            }
                            .padding(.trailing, 10)
                            
                            ScalePercentageText(scale: obj.appearance.logoOffsetX, maxScale: 360 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                        }
                        .padding()
                        
                        
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                                .popOverInfo(isPresented: $showPopover_LogoOffsetY) {
                                    Text("Move the imported logo up or down")
                                }
                            
                            Text("Logo Offset")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            
                            CustomSlider(value: $obj.appearance.logoOffsetY, inRange: -360...360, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            }
                            .padding(.trailing, 10)
                            
                            ScalePercentageText(scale: obj.appearance.logoOffsetY, maxScale: 360 / 0.5, fontSize: obj.appearance.settingsSliderFontSize)
                        }
                        .padding()
                        
                        HStack {
                            Image(systemName: "arrow.circlepath")
                                .popOverInfo(isPresented: $showPopover_LogoRotation) {
                                    Text("Rotate the imported logo")
                                }
                            
                            Text("Rotation")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            
                            CustomSlider(value: $obj.appearance.logoRotate, inRange: -180...180, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            }
                            
                            Text("\(abs(obj.appearance.logoRotate), specifier: "%.0f")°")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .frame(width: 40)
                        }
                        .padding()
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


