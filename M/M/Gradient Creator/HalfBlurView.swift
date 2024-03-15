//
//  HalfBlurView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct HalfBlurView: View {
    
    @Binding var showHalfBlur: Bool
    @Binding var halfBlurLeft: Bool
    @Binding var halfBlurShadowOpacity: CGFloat
    
    var body: some View {
        if showHalfBlur {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background {
                        TransparentBlurView(removeAllFilters: true)
                            .blur(radius: 50, opaque: true)
                    }
                    .shadow(radius: 10)
                    .shadow(color: .black.opacity(halfBlurShadowOpacity), radius: 10)
                    .offset(x: halfBlurLeft ? UIScreen.main.bounds.width * 0.5 : -UIScreen.main.bounds.width * 0.5)
            }
            .background(Color.clear)
        }
    }
}
