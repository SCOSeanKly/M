//
//  CustomToggle3Way.swift
//  M
//
//  Created by Sean Kelly on 09/11/2023.
//

import SwiftUI

enum ToggleState {
    case first, second, third
}

struct CustomToggle3Way: View {
    let showTitleText: Bool
    let titleText: String
    let bindingValues: Binding<[ToggleState]>
    let symbols: [String]
    let rotate: Bool
    let colors: [Color]
    @State private var xOffset: CGFloat = -10
    var obj: Object
    @State private var isTapped: Bool = false
    @State private var rotationAngle: Angle = .degrees(0)
    
    var body: some View {
        
       
        HStack {
            if showTitleText {
                Text(titleText)
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                
                Spacer()
            }
            
            ZStack {
                
                Capsule()
                    .frame(width: 44, height: 24)
                    .foregroundColor(getColorForState())
                    .animation(.easeInOut, value: bindingValues.wrappedValue)
                
                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.white.opacity(0.1), Color.white.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 44, height: 24)
                    .cornerRadius(100)
                    .overlay{
                        Capsule()
                            .stroke(
                                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.black.opacity(0.2)]), startPoint: .bottom, endPoint: .top),
                                lineWidth: 0.5
                            )
                    }
                   
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
                        .overlay(
                            Image(systemName: symbols[bindingValues.wrappedValue.firstIndex { $0 == .first } ?? 0])
                                .foregroundColor(.gray.opacity(1))
                                .font(.system(size: 14))
                                .rotationEffect(rotationAngle)
                              // .contentTransition(.symbolEffect(.replace))
                            
                        )
                }
                .offset(x: xOffset, y: 0)
            }
            .onTapGesture {
                // Other onTapGesture code...
                let updatedStates = getNextStates()
                bindingValues.wrappedValue = updatedStates
                withAnimation(.snappy) {
                    
                    // Adjust the xOffset based on the current state
                    xOffset = xOffset == 0 ? 10 : (xOffset == 10 ? -10 : 0)
                    
                if rotate {
                 
                        // Set rotation angle based on the current state
                        switch bindingValues.wrappedValue.firstIndex(where: { $0 == .first }) {
                        case 0:
                            rotationAngle = .degrees(0)
                        case 1:
                            rotationAngle = .degrees(180)
                        case 2:
                            rotationAngle = .degrees(90)
                        default:
                            rotationAngle = .degrees(240)
                        }
                    }
                }
                
                isTapped.toggle()
              
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
        .sensoryFeedback(.selection, trigger: isTapped)
    }
    
    private func getColorForState() -> Color {
        return colors[bindingValues.wrappedValue.firstIndex { $0 == .first } ?? 0]
    }
    
    private func getNextStates() -> [ToggleState] {
        var updatedStates = bindingValues.wrappedValue
        
        // Rotate the states in a specific order
        let first = updatedStates.removeFirst()
        updatedStates.append(first)
        
        return updatedStates
    }
}
