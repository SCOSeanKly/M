//
//  AnimatedButton.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct AnimatedButton: View {
    
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isAnimating: Bool = false
 
    var action: () -> Void
    var sfSymbolName: String
    var rotationAntiClockwise: Bool
    var color: Color
    var allowRotation: Bool
    
    var body: some View {
        
        Button {
            feedback()
            isAnimating.toggle()
            action()
            feedback()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAnimating.toggle()
            }
            
        } label: {
            if isAnimating {
                Image(systemName: sfSymbolName)
                    .font(.title2)
                    .rotationEffect(rotationAngle)
                    .animation(.easeInOut(duration: 1.5), value: rotationAngle)
                    .onAppear {
                        if allowRotation {
                            rotationAngle = .degrees(rotationAntiClockwise ? -720 : 720)
                        }
                    }
                    .onDisappear {
                        rotationAngle = .degrees(0)
                    }
            } else {
                Image(systemName: sfSymbolName)
                    .font(.title2)
            }
        }
        .tint(color)
        
    }
}
