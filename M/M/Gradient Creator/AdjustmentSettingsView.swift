//
//  AdjustmentSettingsView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI


struct AdjustmentSettingsView: View {
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let horizontalPadding: CGFloat = 8
    @Binding var isSavingImage: Bool
    @Binding var gradientBlur: CGFloat
    @Binding var gradientScale: CGFloat
    @Binding var gradientRotation: Angle
    @Binding var gradientOffsetX: CGFloat
    @Binding var gradientOffsetY: CGFloat
    @Binding var importedBackground: UIImage?
    @Binding var importedImageOverlay: UIImage?
    @Binding var pixellate: CGFloat
    @Binding var amplitude: CGFloat
    @Binding var frequency: CGFloat
    @Binding var showHalfBlur: Bool
    @Binding var gradientHue: CGFloat
    @Binding var gradientSaturation: CGFloat
    @Binding var gradientBrightness: CGFloat
    @Binding var gradientContrast: CGFloat
    @Binding var selectedColorCount: Int
    @Binding var gradientColors: [Color]
    @Binding var bgColor: Color
    @Binding var showGradientControl: Bool
    @Binding var refreshButtonTapped: Bool
    
    @State private var gradientOffsetSliderMoved = false
    @State private var rotationSliderMoved = false
    @State private var waveSliderMoved = false
    @State private var isTapped: Bool = false
    @Binding var showPopoverGradientWall: Bool
    
    var body: some View {
        if !isSavingImage {
            //MARK: Title
            HStack {
                Text("Adjustment Settings")
                    .font(.headline)
                
                Spacer()
                
                // Reset button
                AnimatedButton(action: {
                    // Reset all values
                    gradientBlur = 0
                    gradientScale = 1
                    gradientRotation = .zero
                    gradientOffsetX = 0
                    gradientOffsetY = 0
                    importedBackground = nil
                    importedImageOverlay = nil
                    pixellate = 1
                    amplitude = 5
                    frequency = 200
                    showHalfBlur = false
                    gradientHue = 0
                    gradientSaturation = 1
                    gradientBrightness = 0
                    gradientContrast = 1
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                
                // Info button
                Button {
                    // Toggle popover view
                    isTapped.toggle()
                    showPopoverGradientWall.toggle()
                } label: {
                    Label("", systemImage: showPopoverGradientWall ? "xmark.circle" : "info.circle")
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
                        .padding(.trailing)
                        .offset(y: 12)
                    VStack {
                        
                        Text("\(Int((gradientOffsetX / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                        
                        CustomSlider(value: $gradientOffsetX, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            self.gradientOffsetSliderMoved = started // Update the state when the slider is moved
                        }
                        .frame(width: sliderScale.width * 0.28)
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.trailing)
                        .offset(x: 15, y: 12)
                    VStack {  Text("\(Int((gradientOffsetY / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                        
                        CustomSlider(value: $gradientOffsetY, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                            self.gradientOffsetSliderMoved = started // Update the state when the slider is moved
                        }
                        .frame(width: sliderScale.width * 0.28)
                    }
                    
                    AnimatedButton(action: {
                        gradientOffsetX = 0
                        gradientOffsetY = 0
                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.leading, 8)
                    .offset(y: 12)
                    .scaleEffect(0.8)
                    .disabled(!gradientOffsetSliderMoved)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                //MARK: Hue Slider
                SliderView(systemName: "camera.filters", sliderTitle: "Hue", blurSystemName: false, value: $gradientHue, inValue: -180, outValue: 180, resetValue: 0)
                
                //MARK: Sat Slider
                SliderView(systemName: "drop.halffull", sliderTitle: "Saturation", blurSystemName: false, value: $gradientSaturation, inValue: 0, outValue: 2, resetValue: 1)
                
                //MARK: Contrast Slider
                SliderView(systemName: "circle.lefthalf.striped.horizontal", sliderTitle: "Contrast", blurSystemName: false, value: $gradientContrast, inValue: 0.1, outValue: 3, resetValue: 1)
                //MARK: Brightneass Slider
                SliderView(systemName: "sun.max", sliderTitle: "Brightness", blurSystemName: false, value: $gradientBrightness, inValue: -1, outValue: 1, resetValue: 0)
                
                //MARK: Blur Slider
                SliderView(systemName: "scribble.variable", sliderTitle: "Blur", blurSystemName: true, value: $gradientBlur, inValue: 0, outValue: 100, resetValue: 0)
                
                //MARK: Scale Slider
                SliderView(systemName: "arrow.up.left.and.arrow.down.right", sliderTitle: "Scale", blurSystemName: false, value: $gradientScale, inValue: 0, outValue: 3.5, resetValue: 1)
                
                //MARK: Rotation Slider
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    
                    Text("Rotation")
                        .font(.system(size: 12.5))
                    
                    CustomSlider(value: $gradientRotation.degrees, inRange: 0...360, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        self.rotationSliderMoved = started
                    }
                    
                    Text("\(Int(gradientRotation.degrees))°")
                        .font(.system(size: 10))
                        .padding(.horizontal, 8)
                        .lineLimit(1) // Ensure text doesn't exceed one line
                        .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                        .frame(width: 50)
                    
                    AnimatedButton(action: {
                        gradientRotation.degrees = 0
                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .scaleEffect(0.8)
                    .disabled(!rotationSliderMoved || gradientRotation.degrees == 0)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                //MARK: Chequered Slider
                SliderView(systemName: "rectangle.checkered", sliderTitle: "Pixellate", blurSystemName: false, value: $pixellate, inValue: 1, outValue: 75, resetValue: 1)
                
                //MARK: Wave effect Slider
                HStack {
                    Image(systemName: "water.waves")
                    
                    Text("Wave")
                        .font(.system(size: 12.5))
                    
                    CustomSlider(value: $amplitude, inRange: 0...100, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        self.waveSliderMoved = started
                    }
                    
                    CustomSlider(value: $frequency, inRange: 0.001...200, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                        self.waveSliderMoved = started
                    }
                    
                    AnimatedButton(action: {
                        //  speed = 0
                        amplitude = 0
                        frequency = 200
                    }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.leading, 8)
                    .scaleEffect(0.8)
                    .disabled(!waveSliderMoved)
                    .disabled(amplitude == 0 && frequency == 200)
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
                    }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true)
                    
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
    func generateGradient() {
        let selectedColors = gradientColors.prefix(selectedColorCount)
        gradientColors = selectedColors.shuffled() + gradientColors.dropFirst(selectedColorCount)
        refreshButtonTapped.toggle()
    }
}
