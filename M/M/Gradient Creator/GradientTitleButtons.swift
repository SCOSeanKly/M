//
//  GradientTitleButtons.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct GradientTitleButtons: View {
    
    @Binding var showSheetBackground: Bool
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
    @Binding var allowPixellateEffect: Bool
    @Binding var blendModeEffects: BlendMode
    @Binding var effectsOpacity: CGFloat


    var body: some View {
        HStack {
            Text("Adjustment Settings")
                .font(.headline)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text("Adjustment Settings")
                        .font(.headline)
                        .blendMode(.hue)
                }
                .overlay{
                    Text("Adjustment Settings")
                        .font(.headline)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text("Adjustment Settings")
                        .font(.headline)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Spacer()
            
            AnimatedButton(action: {
                showSheetBackground.toggle()
            }, sfSymbolName: "circle.dotted.and.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
           
            
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
                allowPixellateEffect = false
                blendModeEffects = .normal
                effectsOpacity = 1
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
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Label("", systemImage: showPopoverGradientWall ? "xmark.circle" : "info.circle")
                            .font(.title2)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Label("", systemImage: showPopoverGradientWall ? "xmark.circle" : "info.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Label("", systemImage: showPopoverGradientWall ? "xmark.circle" : "info.circle")
                            .font(.title2)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
            }
            .buttonStyle(.plain)
            .contentTransition(.symbolEffect(.replace))
            .sensoryFeedback(.selection, trigger: isTapped)
        }
        .padding(.horizontal)
        .padding(.horizontal, 4)
        .padding(.top)
    }
}
