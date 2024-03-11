//
//  ReOrderGradientButton.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct ReOrderGradientButton: View {
    
    @Binding var selectedColorCount: Int
    @Binding var gradientColors: [Color]
    @Binding var refreshButtonTapped: Bool
    
    var body: some View {
        HStack {
            
            UltraThinButton(action: {
                
                generateGradient()

            }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
            
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
    
    func generateGradient() {
        let selectedColors = gradientColors.prefix(selectedColorCount)
        gradientColors = selectedColors.shuffled() + gradientColors.dropFirst(selectedColorCount)
        refreshButtonTapped.toggle()
    }
    
}
