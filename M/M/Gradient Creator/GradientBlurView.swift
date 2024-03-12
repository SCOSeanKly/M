//
//  GradientBlurView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct GradientBlurView: View {
    
    @Binding var blurBinding: CGFloat

    var body: some View {
        ZStack {
            if blurBinding > 0.001 {
                Rectangle()
                    .foregroundColor(.clear)
                    .background {
                        TransparentBlurView(removeAllFilters: true)
                            .blur(radius: blurBinding, opaque: true)
                    }
            }
        }
        .background(Color.clear)
    }
}
