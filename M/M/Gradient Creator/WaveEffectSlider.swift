//
//  WaveEffectSlider.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct WaveEffectSlider: View {
    
    @Binding var amplitude: CGFloat
    @Binding var frequency: CGFloat
    @Binding var waveSliderMoved: Bool
    
    var body: some View {
        //MARK: Wave effect Slider
        HStack {
            Image(systemName: "water.waves")
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: "water.waves")
                        .font(.headline)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: "water.waves")
                        .font(.headline)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: "water.waves")
                        .font(.headline)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
            Text("Wave")
                .font(.system(size: 12.5))
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Text("Wave")
                        .font(.system(size: 12.5))
                        .blendMode(.hue)
                }
                .overlay{
                    Text("Wave")
                        .font(.system(size: 12.5))
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Text("Wave")
                        .font(.system(size: 12.5))
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            
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
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
