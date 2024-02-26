//
//  CustomToggleBlend.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct CustomToggleBlend: View {
    let showTitleText: Bool
    let titleText: String
    let bindingValue: Binding<Bool>
    let bindingValue2: Binding<Bool>?
    let onSymbol: String
    let offSymbol: String
    let rotate: Bool
    let onColor: Color
    let offColor: Color
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isPressing: Bool = false
    @StateObject var obj = Object()
    @State private var isTapped: Bool = false
    
    var body: some View {
        
        HStack {
            if showTitleText {
                Text(titleText)
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Text(titleText)
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .blendMode(.hue)
                    }
                    .overlay{
                        Text(titleText)
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Text(titleText)
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                
                Spacer()
            }
            
            ZStack {
                
                Capsule()
                    .frame(width: 40, height: 24)
                    .foregroundColor(Color(bindingValue.wrappedValue ? onColor : offColor))
                    .animation(.easeInOut, value: bindingValue.wrappedValue)
                
                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.white.opacity(0.1), Color.white.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 40, height: 24)
                    .cornerRadius(100)
                
                ZStack {
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.15), radius: 1, x: 2, y: 2)
                    
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.1), .white.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom))
                        .clipShape(Circle())
                    
                    ZStack {
                        Image(systemName: bindingValue.wrappedValue ? onSymbol : offSymbol)
                            .scaleEffect(0.7)
                            .rotationEffect(rotationAngle)
                            .foregroundColor(.white.opacity(0.6))
                            .offset(x: -0.5, y: -0.5)
                        
                        Image(systemName: bindingValue.wrappedValue ? onSymbol : offSymbol)
                            .scaleEffect(0.7)
                            .rotationEffect(rotationAngle)
                            .foregroundColor(.gray.opacity(0.5))
                            .offset(x: 0.5, y: 0.5)
                        
                        Image(systemName: bindingValue.wrappedValue ? onSymbol : offSymbol)
                            .scaleEffect(0.7)
                            .rotationEffect(rotationAngle)
                            .foregroundColor(.black)
                    }
                    .shadow(color: .black.opacity(0.15), radius: 0.2, x: 0.25, y: 1.0)
                }
                .overlay{
                    Circle()
                        .foregroundColor(.black.opacity(isPressing ? 0.05 : 0))
                }
                .offset(x: bindingValue.wrappedValue ? 9 : -9)
                .scaleEffect(isPressing ? 0.8 : 1.0)
                .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isPressing)
            }
            .onTapGesture {
                
                isTapped.toggle()
                isPressing.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressing.toggle()
                }
                
                bindingValue.wrappedValue.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    bindingValue2?.wrappedValue.toggle()
                }
            
                
                if rotate {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        rotationAngle = bindingValue.wrappedValue ? .degrees(90) : .degrees(0)
                    }
                }
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
        .sensoryFeedback(.impact, trigger: isTapped)
    }
}
