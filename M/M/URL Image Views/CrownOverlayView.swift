//
//  StarView.swift
//  M
//
//  Created by Sean Kelly on 05/12/2023.
//

import SwiftUI


struct CrownOverlayView: View {

    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.yellow.gradient)
                
            }
            .padding(10)
          
            Spacer()
        }
        .scrollTransition(.animated.threshold(.visible(0.1))) { content, phase in
            content
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
        }
    }
}

