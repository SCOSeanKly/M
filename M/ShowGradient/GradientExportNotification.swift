//
//  GradientExportNotification.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 13/06/2023.
//
import SwiftUI
//import Shimmer

struct GradientSavedNotification: View {
    
    let notificationSize = CGSize(width: UIScreen.main.bounds.width * 0.55, height: UIScreen.main.bounds.width * 0.16)
    let notificationCornerRadius: CGFloat = 20
    let notificationOffset: CGFloat = UIScreen.main.bounds.height * 0.375
    let animationDuration = 0.5
    @Binding var isShowingGradientSavedNotification: Bool
    @State private var rotationAngle: Angle = .degrees(0)
    
    
    var body: some View {
            
            VStack {
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: notificationCornerRadius)
                        .foregroundColor(.clear)
                        .background(.thinMaterial)
                        .frame(width: notificationSize.width, height: notificationSize.height)
                        .colorScheme(.dark)
                        .clipShape(RoundedRectangle(cornerRadius: notificationCornerRadius))
                        .overlay(RoundedRectangle(cornerRadius: notificationCornerRadius).stroke(Color.lightGray, lineWidth: 0.4))
                        .shadow(color: Color.black.opacity(0.4), radius: 4)
                    
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .padding(.trailing, 10)
                            
                            Text("SAVED TO PHOTOS")
                        }
                        .font(.body)
                        .foregroundColor(.white)
                        
                        HStack {
                            
                            Text("FORMAT")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .frame(width: 36, height: 21)
                                    .foregroundColor(.gray)
                                
                                Text("PNG")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .scaleEffect(0.8)
                            }
                        }
                    }
                    
                }
                .padding()
            }
            .scaleEffect(0.9)
            .offset(y: isShowingGradientSavedNotification ? 0 : UIScreen.main.bounds.height)
            .animation(Animation.easeInOut(duration: animationDuration), value: isShowingGradientSavedNotification)
            .shadow(color: Color.black.opacity(0.4), radius: 4, y: 2)
    }
}

