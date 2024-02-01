//
//  AICustomTextModifier.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

struct AICustomTextModifier: ViewModifier {
    let customPadding: CGFloat
    let cornerRadius: CGFloat
    let strokeOpacity: CGFloat
    
    init(customPadding: CGFloat, cornerRadius: CGFloat, strokeOpacity: CGFloat) {
        self.customPadding = customPadding
        self.cornerRadius = cornerRadius
        self.strokeOpacity = strokeOpacity
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 10, weight: .regular, design: .rounded))
            .foregroundColor(.primary)
            .padding(customPadding)
            .padding(.horizontal, 5)
            .background {
                
                Color.primary.colorInvert()
                
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 15, opaque: true)
            }
            .cornerRadius(cornerRadius)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary, lineWidth: strokeOpacity)
                    .opacity(0.4)
            )
    }
}
