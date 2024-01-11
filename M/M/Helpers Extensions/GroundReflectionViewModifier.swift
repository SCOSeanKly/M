//
//  GroundReflectionViewModifier.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

private struct GroundReflectionViewModifier: ViewModifier {
    let offsetY: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                content
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [.init(color: .black, location: 0.075), .init(color: .clear, location: 0.2)]),
                            startPoint: .bottom,
                            endPoint: .top)
                    )
                    .scaleEffect(x: 1.0, y: -1.0, anchor: .bottom)
                    .offset(y: offsetY)
            )
    }
}

extension View {
    func reflection(offsetY: CGFloat = 1) -> some View {
        modifier(GroundReflectionViewModifier(offsetY: offsetY))
    }
}


