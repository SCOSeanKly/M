//
//  SliderView.swift
//  M
//
//  Created by Sean Kelly on 16/02/2024.
//

import SwiftUI

struct SliderView: View {
    let bottomPadding: CGFloat = 8
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    let scaleEffect: CGFloat = 0.8
    
    let systemName: String
    let blurSystemName: Bool
    @Binding var value: CGFloat
    let inValue: CGFloat
    let outValue: CGFloat
    let resetValue: CGFloat
    
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(.title2)
                .padding(.trailing)
                .blur(radius: blurSystemName ? 2 : 0)
            
            
            CustomSlider(value: $value, inRange: inValue...outValue, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
            }
            
            Text("\(Int(value))")
                .font(.footnote)
                .padding(.leading)
            
            AnimatedButton(action: {
                value = resetValue
            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
            .padding(.leading, 8)
            
        }
        .frame(width: sliderScale.width)
        .scaleEffect(scaleEffect)
        .padding(.bottom, bottomPadding)
    }
}
