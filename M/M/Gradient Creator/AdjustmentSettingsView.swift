//
//  AdjustmentSettingsView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//


import SwiftUI
import SwiftUIKit


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
    @State private var showSheetBackground: Bool = false
    @Binding var invertGradient: Bool
    @Binding var blendModeImportedBackground: BlendMode
    @Binding var blendModeEffects: BlendMode
    @Binding var allowPixellateEffect: Bool
    @Binding var importedBackgroundOpacity: CGFloat
    @Binding var effectsOpacity: CGFloat
    @Binding var hideGradient: Bool
    @Binding var importedBackgroundBlur: CGFloat
    @Binding var importedBackgroundHue: CGFloat
    @Binding var importedBackgroundSaturation: CGFloat
    @Binding var importedBackgroundBrightness: CGFloat
    @Binding var importedBackgroundContrast: CGFloat
    @Binding var halfBlurLeft: Bool
    @Binding var halfBlurShadowOpacity: CGFloat
    
  
    var body: some View {
        if !isSavingImage {
            
            GradientTitleButtons(showSheetBackground: $showSheetBackground, isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, isTapped: $isTapped, showPopoverGradientWall: $showPopoverGradientWall, allowPixellateEffect: $allowPixellateEffect, blendModeEffects: $blendModeEffects, effectsOpacity: $effectsOpacity, importedBackgroundBlur: $importedBackgroundBlur, importedBackgroundHue: $importedBackgroundHue, importedBackgroundSaturation: $importedBackgroundSaturation, importedBackgroundBrightness: $importedBackgroundBrightness, importedBackgroundContrast: $importedBackgroundContrast, importedBackgroundOpacity: $importedBackgroundOpacity, hideGradient: $hideGradient, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground)
            
            ScrollView {
                GradientSlidersButtons(showSheetBackground: $showSheetBackground, isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, isTapped: $isTapped, showPopoverGradientWall: $showPopoverGradientWall, gradientOffsetSliderMoved: $gradientOffsetSliderMoved, rotationSliderMoved: $rotationSliderMoved, waveSliderMoved: $waveSliderMoved, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, blendModeEffects: $blendModeEffects, allowPixellateEffect: $allowPixellateEffect, effectsOpacity: $effectsOpacity, hideGradient: $hideGradient, importedBackgroundBlur: $importedBackgroundBlur, importedBackgroundHue: $importedBackgroundHue, importedBackgroundSaturation: $importedBackgroundSaturation, importedBackgroundBrightness: $importedBackgroundBrightness,  importedBackgroundContrast: $importedBackgroundContrast, halfBlurLeft: $halfBlurLeft, halfBlurShadowOpacity: $halfBlurShadowOpacity)
            }
            .modifier(PresentationModifiers(showSheetBackground: $showSheetBackground))
          
        }
    }
}


struct PresentationModifiers: ViewModifier {
    @Binding var showSheetBackground: Bool

    func body(content: Content) -> some View {
        content
            .padding(.bottom)
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(20)
            .presentationBackground(showSheetBackground ? Color.primary.colorInvert() : Color.clear)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .ignoresSafeArea()
    }
}
