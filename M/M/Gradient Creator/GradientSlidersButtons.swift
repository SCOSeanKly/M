//
//  GradientSlidersButtons.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct GradientSlidersButtons: View {
    
    @Binding var showSheetBackground: Bool
    
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
    @Binding var isTapped: Bool
    @Binding var showPopoverGradientWall: Bool
    @Binding var gradientOffsetSliderMoved: Bool
    @Binding var rotationSliderMoved: Bool
    @Binding var waveSliderMoved: Bool
    @Binding var invertGradient: Bool
    @Binding var blendModeImportedBackground: BlendMode
    @Binding var blendModeEffects: BlendMode
    @Binding var allowPixellateEffect: Bool
    @Binding var effectsOpacity: CGFloat
    @Binding var hideGradient: Bool
    @Binding var importedBackgroundBlur: CGFloat
    @Binding var importedBackgroundHue: CGFloat
    @Binding var importedBackgroundSaturation: CGFloat
    @Binding var importedBackgroundBrightness: CGFloat
    @Binding var importedBackgroundContrast: CGFloat
      
    
    
    
    var body: some View {
        
        
        SlidersTitleView(titleText: "Gradient")
        
        //MARK: Disable Gradient
        HStack (spacing: -5) {
            let imageName: String = "square.3.layers.3d.slash"
            Image(systemName: imageName)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: imageName)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
                .padding(.leading)
            
            CustomToggleBlend(showTitleText: true, titleText: "Hide Gradient Layers", bindingValue: $hideGradient, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
            
        }
     //   .padding(.top)
        .offset(y: 6)
        
        if !hideGradient {
            
            //MARK: Horizontal and Vertical Position Sliders
            HorizontalVerticalSliders(gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, gradientOffsetSliderMoved: $gradientOffsetSliderMoved)
            
            //MARK: Hue Slider
            SliderView(systemName: "camera.filters", sliderTitle: "Hue", blurSystemName: false, value: $gradientHue, inValue: -180, outValue: 180, resetValue: 0)
            
            //MARK: Sat Slider
            SliderView(systemName: "drop.halffull", sliderTitle: "Saturation", blurSystemName: false, value: $gradientSaturation, inValue: 0, outValue: 5, resetValue: 1)
            
            //MARK: Contrast Slider
            SliderView(systemName: "circle.lefthalf.striped.horizontal", sliderTitle: "Contrast", blurSystemName: false, value: $gradientContrast, inValue: 0.1, outValue: 3, resetValue: 1)
            
            //MARK: Brightneass Slider
            SliderView(systemName: "sun.max", sliderTitle: "Brightness", blurSystemName: false, value: $gradientBrightness, inValue: -1, outValue: 1, resetValue: 0)
            
            //MARK: Gradient Blur Slider
            SliderView(systemName: "scribble.variable", sliderTitle: "Grad Blur", blurSystemName: true, value: $gradientBlur, inValue: 0, outValue: 100, resetValue: 0)
            
            //MARK: Scale Slider
            SliderView(systemName: "arrow.up.left.and.arrow.down.right", sliderTitle: "Scale", blurSystemName: false, value: $gradientScale, inValue: 0, outValue: 3.5, resetValue: 1)
            
            //MARK: Rotation Slider
            RotationSlider(gradientRotation: $gradientRotation, rotationSliderMoved: $rotationSliderMoved)
            
            //MARK: Chequered Enable Toggle
            HStack (spacing: -5) {
                let imageName: String = "rectangle.checkered"
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Image(systemName: imageName)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                    .padding(.leading)
                
                CustomToggleBlend(showTitleText: true, titleText: "Enable Pixellate", bindingValue: $allowPixellateEffect, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                    .padding(.vertical, 6)
            }
            
            //MARK: Chequered Slider
            SliderView(systemName: "rectangle.checkered", sliderTitle: "Pixellate", blurSystemName: false, value: $pixellate, inValue: 1, outValue: 75, resetValue: 1)
                .disabled(!allowPixellateEffect)
                .opacity(allowPixellateEffect ? 1 : 0.5)
            
            //MARK: Wave effect Slider
            WaveEffectSlider(amplitude: $amplitude, frequency: $frequency, waveSliderMoved: $waveSliderMoved)
            
            //MARK: Add Half Invert Toggle
            HStack (spacing: -5) {
                let imageName: String = "moonphase.first.quarter.inverse"
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Image(systemName: imageName)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                    .padding(.leading)
                
                CustomToggleBlend(showTitleText: true, titleText: "Invert", bindingValue: $invertGradient, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                    .padding(.vertical, 6)
            }
            
            //MARK: Add Half Blur Toggle
            HStack (spacing: -5) {
                let imageName: String = "square.lefthalf.filled"
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Image(systemName: imageName)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Image(systemName: imageName)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                    .padding(.leading)
                
                CustomToggleBlend(showTitleText: true, titleText: "Show Half Blur", bindingValue: $showHalfBlur, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: true, onColor: Color(.systemGreen), offColor: Color(.systemGray))
                    .padding(.vertical, 6)
            }
        }
        
        Divider()
            .padding(.horizontal)
            .padding(.vertical, 5)
        
        SlidersTitleView(titleText:  "Imported Background")
        
        
        //MARK: Imported background blend mode
        HStack (spacing: -5) {
            let imageName: String = "moonphase.first.quarter.inverse"
            Image(systemName: imageName)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: imageName)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
                .padding(.horizontal)
            
            
            let sliderTitle = "Background Blend Mode"
            Text(sliderTitle)
                .font(.system(size: 12.5))
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .blendMode(.hue)
                }
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Spacer()
            
            Picker("Blend Mode", selection: $blendModeImportedBackground) {
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
            .tint(.white)
        }
        
        //MARK: Imported Background Blur Slider
        SliderView(systemName: "scribble.variable", sliderTitle: "BG Blur", blurSystemName: true, value: $importedBackgroundBlur, inValue: 0, outValue: 100, resetValue: 0)
        
        //MARK: Hue Slider
        SliderView(systemName: "camera.filters", sliderTitle: "Hue", blurSystemName: false, value: $importedBackgroundHue, inValue: -180, outValue: 180, resetValue: 0)
        
        //MARK: Sat Slider
        SliderView(systemName: "drop.halffull", sliderTitle: "Saturation", blurSystemName: false, value: $importedBackgroundSaturation, inValue: 0, outValue: 5, resetValue: 1)
        
        //MARK: Contrast Slider
        SliderView(systemName: "circle.lefthalf.striped.horizontal", sliderTitle: "Contrast", blurSystemName: false, value: $importedBackgroundContrast, inValue: 0.1, outValue: 3, resetValue: 1)
        
        //MARK: Brightneass Slider
        SliderView(systemName: "sun.max", sliderTitle: "Brightness", blurSystemName: false, value: $importedBackgroundBrightness, inValue: -1, outValue: 1, resetValue: 0)
      
        Divider()
            .padding(.horizontal)
            .padding(.vertical, 5)
        
        SlidersTitleView(titleText: "Effects")
        
        //MARK: Effects blend mode
        HStack (spacing: -5) {
            let imageName: String = "moonphase.first.quarter.inverse"
            Image(systemName: imageName)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: imageName)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: imageName)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
                .padding(.horizontal)
            
            
            let sliderTitle = "Effects Blend Mode"
            Text(sliderTitle)
                .font(.system(size: 12.5))
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .blendMode(.hue)
                }
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text(sliderTitle)
                        .font(.system(size: 12.5))
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Spacer()
            
            Picker("Blend Mode", selection: $blendModeEffects) {
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
            .tint(.white)
        }
        
        //MARK: Effects Opacity
        SliderView(systemName: "circle.dotted.and.circle", sliderTitle: "Opacity", blurSystemName: false, value: $effectsOpacity, inValue: 0, outValue: 1, resetValue: 1)
        
        if !hideGradient {
            //MARK: Color Picker
            ColorPickerView(gradientColors: $gradientColors, selectedColorCount: $selectedColorCount, bgColor: $bgColor)
            
            //MARK: Re-Order Gradient Button
            ReOrderGradientButton(selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, refreshButtonTapped: $refreshButtonTapped)
                .padding(.bottom, 50)
    }
  }
}




struct SlidersTitleView: View {
    
    let titleText: String
    
    var body: some View {
        HStack {
            Text(titleText)
                .font(.headline)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text(titleText)
                        .font(.headline)
                        .blendMode(.hue)
                }
                .overlay{
                    Text(titleText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text(titleText)
                        .font(.headline)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Spacer()
        }
        .padding(.leading)
        .padding(.vertical, 5)
    }
}





