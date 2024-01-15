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
    @State private var isTapped: Bool = false
 
    var action: () -> Void
    var sfSymbolName: String
    var rotationAntiClockwise: Bool
    var rotationDegrees: Double
    var color: Color
    var allowRotation: Bool
    var showOverlaySymbol: Bool
    var overlaySymbolName: String
    var overlaySymbolColor: Color
    
    
    var body: some View {
        
        Button {
            isTapped.toggle()
            isAnimating.toggle()
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAnimating.toggle()
            }
            
        } label: {
            if isAnimating {
                Image(systemName: sfSymbolName)
                    .font(.title2)
                    .rotationEffect(rotationAngle)
                    .animation(.easeInOut(duration: 1.5), value: rotationAngle)
                    .overlay{
                        if showOverlaySymbol {
                            Image(systemName: overlaySymbolName)
                                .foregroundColor(overlaySymbolColor)
                                .font(.system(size: 10))
                                .padding(2)
                                .background(Color.primary.colorInvert())
                                .clipShape(Circle())
                                .offset(x: -10, y: 10)
                        }
                    }
                    .onAppear {
                        if allowRotation {
                            rotationAngle = .degrees(rotationAntiClockwise ? -rotationDegrees : rotationDegrees)
                        }
                    }
                    .onDisappear {
                        rotationAngle = .degrees(0)
                    }
            } else {
                Image(systemName: sfSymbolName)
                    .font(.title2)
                    .overlay{
                        if showOverlaySymbol {
                            Image(systemName: overlaySymbolName)
                                .foregroundColor(overlaySymbolColor)
                                .font(.system(size: 10))
                                .padding(2)
                                .background(Color.primary.colorInvert())
                                .clipShape(Circle())
                                .offset(x: -10, y: 10)
                        }     
                    }
            }
        }
        .tint(color)
        .sensoryFeedback(.selection, trigger: isTapped)
        
    }
}

struct AvatarAnimatedButton: View {
    
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isAnimating: Bool = false
    @State private var isTapped: Bool = false
 
    var action: () -> Void
    var avatarName: String
    var rotationAntiClockwise: Bool
    var rotationDegrees: Double
    var color: Color
    var allowRotation: Bool
  
    
    
    var body: some View {
        
        Button {
            isTapped.toggle()
            isAnimating.toggle()
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAnimating.toggle()
            }
            
        } label: {
            if isAnimating {
                Image(avatarName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .rotationEffect(rotationAngle)
                    .animation(.easeInOut(duration: 1.5), value: rotationAngle)
                    .onAppear {
                        if allowRotation {
                            rotationAngle = .degrees(rotationAntiClockwise ? -rotationDegrees : rotationDegrees)
                        }
                    }
                    .onDisappear {
                        rotationAngle = .degrees(0)
                    }
            } else {
                Image(avatarName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }
        .tint(color)
        .sensoryFeedback(.selection, trigger: isTapped)
        
    }
}
