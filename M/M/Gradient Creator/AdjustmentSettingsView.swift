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
    @Binding var allowPixellateEffect: Bool
    
    var body: some View {
        if !isSavingImage {
            
            GradientTitleButtons(showSheetBackground: $showSheetBackground, isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, isTapped: $isTapped, showPopoverGradientWall: $showPopoverGradientWall, allowPixellateEffect: $allowPixellateEffect)
            
            ScrollView {
                GradientSlidersButtons(showSheetBackground: $showSheetBackground, isSavingImage: $isSavingImage, gradientBlur: $gradientBlur, gradientScale: $gradientScale, gradientRotation: $gradientRotation, gradientOffsetX: $gradientOffsetX, gradientOffsetY: $gradientOffsetY, importedBackground: $importedBackground, importedImageOverlay: $importedImageOverlay, pixellate: $pixellate, amplitude: $amplitude, frequency: $frequency, showHalfBlur: $showHalfBlur, gradientHue: $gradientHue, gradientSaturation: $gradientSaturation, gradientBrightness: $gradientBrightness, gradientContrast: $gradientContrast, selectedColorCount: $selectedColorCount, gradientColors: $gradientColors, bgColor: $bgColor, showGradientControl: $showGradientControl, refreshButtonTapped: $refreshButtonTapped, isTapped: $isTapped, showPopoverGradientWall: $showPopoverGradientWall, gradientOffsetSliderMoved: $gradientOffsetSliderMoved, rotationSliderMoved: $rotationSliderMoved, waveSliderMoved: $waveSliderMoved, invertGradient: $invertGradient, blendModeImportedBackground: $blendModeImportedBackground, allowPixellateEffect: $allowPixellateEffect)
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
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
            .presentationBackground(showSheetBackground ? Color.primary.colorInvert() : Color.clear)
            .ignoresSafeArea()
    }
}
