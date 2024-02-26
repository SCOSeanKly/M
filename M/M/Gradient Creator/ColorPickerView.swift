//
//  ColorPickerView.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var gradientColors: [Color]
    @Binding var selectedColorCount: Int
    @Binding var bgColor: Color
    let horizontalPadding: CGFloat = 8
    
    var body: some View {
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
    }
}
