//
//  GradientBlurView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct GradientBlurView: View {
    
    @Binding var gradientBlur: CGFloat
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if gradientBlur > 0.001 {
            Rectangle()
                .foregroundColor(.clear)
                .background {
                    TransparentBlurView(removeAllFilters: true)
                        .blur(radius: gradientBlur, opaque: true)
                        .frame(width: screenWidth, height: screenHeight)
                }
        }
    }
}
