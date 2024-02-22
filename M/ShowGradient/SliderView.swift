//
//  SliderView.swift
//  M
//
//  Created by Sean Kelly on 16/02/2024.
//

import SwiftUI

struct SliderView: View {
    let bottomPadding: CGFloat = 10
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let scaleEffect: CGFloat = 0.95
    
    let systemName: String
    let sliderTitle: String
    let blurSystemName: Bool
    @Binding var value: CGFloat
    let inValue: CGFloat
    let outValue: CGFloat
    let resetValue: CGFloat
    
    @State private var sliderMoved = false // Track whether the slider has been moved
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .blur(radius: blurSystemName ? 2 : 0)
            
            Text(sliderTitle)
                .font(.system(size: 12.5))
            
            CustomSlider(value: $value, inRange: inValue...outValue, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                self.sliderMoved = started // Update the state when the slider is moved
            }
          
            Text(resetValue > 1000 ? "\(Int(value))" : "\(String(format: "%.1f", value))")
                   .font(.system(size: 10))
                   .padding(.horizontal, 8)
                   .lineLimit(1)
                   .minimumScaleFactor(0.5)
                   .frame(width: 50)

            AnimatedButton(action: {
                value = resetValue
            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
            .scaleEffect(0.8)
            .disabled(!sliderMoved || value == resetValue) // Disable the button if the slider hasn't been moved or if the value equals the reset value
            
        }
        .padding(.vertical, bottomPadding)
        .padding(.horizontal)
    }
}


