//
//  HalfBlurView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct HalfBlurView: View {
    
    @Binding var showHalfBlur: Bool
    
    var body: some View {
        if showHalfBlur {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background {
                        TransparentBlurView(removeAllFilters: true)
                            .blur(radius: 25, opaque: true)
                    }
                    .shadow(radius: 10)
                    .offset(x: -UIScreen.main.bounds.width * 0.5)
            }
            .background(Color.clear)
        }
    }
}
