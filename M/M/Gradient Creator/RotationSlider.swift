//
//  RotationSlider.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct RotationSlider: View {
    
    @Binding var gradientRotation: Angle
    @Binding var rotationSliderMoved: Bool
    
    var body: some View {
        //MARK: Rotation Slider
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Text("Rotation")
                .font(.system(size: 12.5))
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text("Rotation")
                        .font(.system(size: 12.5))
                        .blendMode(.hue)
                }
                .overlay{
                    Text("Rotation")
                        .font(.system(size: 12.5))
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text("Rotation")
                        .font(.system(size: 12.5))
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            CustomSlider(value: $gradientRotation.degrees, inRange: 0...360, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                self.rotationSliderMoved = started
            }
            
            Text("\(Int(gradientRotation.degrees))°")
                .font(.system(size: 10))
                .padding(.horizontal, 8)
                .lineLimit(1) // Ensure text doesn't exceed one line
                .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                .frame(width: 50)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text("\(Int(gradientRotation.degrees))°")
                        .font(.system(size: 10))
                        .padding(.horizontal, 8)
                        .lineLimit(1) // Ensure text doesn't exceed one line
                        .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                        .frame(width: 50)
                        .blendMode(.hue)
                }
                .overlay{
                    Text("\(Int(gradientRotation.degrees))°")
                        .font(.system(size: 10))
                        .padding(.horizontal, 8)
                        .lineLimit(1) // Ensure text doesn't exceed one line
                        .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                        .frame(width: 50)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text("\(Int(gradientRotation.degrees))°")
                        .font(.system(size: 10))
                        .padding(.horizontal, 8)
                        .lineLimit(1) // Ensure text doesn't exceed one line
                        .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                        .frame(width: 50)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            AnimatedButton(action: {
                gradientRotation.degrees = 0
            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
            .scaleEffect(0.8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
