//
//  customFrameBasedOnCondition.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customFrameBasedOnCondition(obj: Object) -> some View {
        let columns: CGFloat = obj.appearance.showTwoWallpapers ? 2.5 : 4
        customFrame(columns: columns)
    }
    
    func customFrame(columns: CGFloat, borderThickness: CGFloat = 0.5, borderColor: Color = .primary) -> some View {
        let width = UIScreen.main.bounds.width / columns
        let height = UIScreen.main.bounds.height / columns
        
        return self
            .frame(width: width, height: height)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(columns == 2.5 ? 25 : 15)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: columns == 2.5 ? 25 : 15)
                    .stroke(borderColor, lineWidth: borderThickness)
                    .opacity(0.4)
            )
            .scrollTransition(.animated.threshold(.visible(0.1))) { content, phase in
                content
                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
            }
    }
}

