//
//  HalfBlurView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct HalfBlurView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @Binding var showHalfBlur: Bool
    
    var body: some View {
        if showHalfBlur {
            Rectangle()
                .foregroundColor(.clear)
                .background {
                    TransparentBlurView(removeAllFilters: true)
                        .blur(radius: 25, opaque: true)
                        .frame(width: screenWidth, height: screenHeight)
                }
                .shadow(radius: 10)
                .offset(x: -UIScreen.main.bounds.width * 0.5)
        }
    }
}
