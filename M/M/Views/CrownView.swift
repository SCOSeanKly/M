//
//  Crownview.swift
//  M
//
//  Created by Sean Kelly on 04/01/2024.
//

import SwiftUI

struct CrownView: View {
    
    @State private var shine: Bool = false
    
    var body: some View {
        Image(systemName: "crown.fill")
            .font(.title3)
            .foregroundStyle(.yellow.gradient)
            .shineCrown(shine, duration: 1.5, rightToLeft: false)
            .onAppear {
                // Start a timer to toggle shine every 2 seconds
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                    shine.toggle()
                }
            }
    }
}

extension View {
    /// Custom View Modifier
    @ViewBuilder
    func shineCrown(_ toggle: Bool, duration: CGFloat = 0.5, rightToLeft: Bool = false) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    /// Eliminating Negative Duration
                    let moddedDuration = max(0.3, duration)
                    
                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(0.75),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + (progress * (size.width * 2)))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.init(degrees: 45))
                        /// Simply Flipping View in Horizontal Direction
                        .scaleEffect(x: rightToLeft ? -1 : 1)
                }
            }
            .mask{
                Image(systemName: "crown.fill")
            }
           
    }
}
