//
//  OnBoarding.swift
//  M
//
//  Created by Sean Kelly on 12/02/2024.
//

import SwiftUI

struct OnBoarding: View {
    @Binding var showOnboarding: Bool
    let imageNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]

    var body: some View {
        
        VStack {
            HStack{
                
                Spacer()
                Button{
                    showOnboarding = false
                } label: {
                    Circle()
                        .fill(.red)
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "xmark.circle")
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundColor(.white)
                        }
                        .padding(.trailing)
                }
            }
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 150) {
                        ForEach(imageNames, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(40)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(x: scrollOffset(geometryProxy))
                                }
                                .containerRelativeFrame(.horizontal)
                            
                        }
                    }
                }
            .scrollTargetLayout()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
              
            }
        
     
          
        }
    }

func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
    let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
    
    return -minX * min(0.6, 1.0)
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding(showOnboarding: .constant(true))
    }
}
