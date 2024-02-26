//
//  HorizontalVerticalSliders.swift
//  M
//
//  Created by Sean Kelly on 26/02/2024.
//

import SwiftUI

struct HorizontalVerticalSliders: View {
    let sliderScale = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.15)
    @Binding var gradientOffsetX: CGFloat
    @Binding var gradientOffsetY: CGFloat
    @Binding var gradientOffsetSliderMoved: Bool
    
    var body: some View {
        //MARK: Horizontal and Vertical Position Sliders
        HStack{
            
            Image(systemName: "arrow.left.arrow.right")
                .padding(.trailing)
                .offset(y: 12)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: "arrow.left.arrow.right")
                        .padding(.trailing)
                        .offset(y: 12)
                        .font(.headline)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: "arrow.left.arrow.right")
                        .padding(.trailing)
                        .offset(y: 12)
                        .font(.headline)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: "arrow.left.arrow.right")
                        .padding(.trailing)
                        .offset(y: 12)
                        .font(.headline)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            VStack {
                
                Text("\(Int((gradientOffsetX / 1000) * 100))%")
                    .font(.system(size: 10))
                    .padding(.horizontal, 8)
                    .lineLimit(1) // Ensure text doesn't exceed one line
                    .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Text("\(Int((gradientOffsetX / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Text("\(Int((gradientOffsetX / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Text("\(Int((gradientOffsetX / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                
                CustomSlider(value: $gradientOffsetX, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    self.gradientOffsetSliderMoved = started // Update the state when the slider is moved
                }
                .frame(width: sliderScale.width * 0.28)
                
            }
            
            Spacer()
            
            Image(systemName: "arrow.up.arrow.down")
                .padding(.trailing)
                .offset(x: 15, y: 12)
                .foregroundColor(.white)
                .blendMode(.difference)
                .overlay{
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.trailing)
                        .offset(x: 15, y: 12)
                        .blendMode(.hue)
                }
                .overlay{
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.trailing)
                        .offset(x: 15, y: 12)
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                }
                .overlay{
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.trailing)
                        .offset(x: 15, y: 12)
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                }
            VStack {
                Text("\(Int((gradientOffsetY / 1000) * 100))%")
                    .font(.system(size: 10))
                    .padding(.horizontal, 8)
                    .lineLimit(1) // Ensure text doesn't exceed one line
                    .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                    .overlay{
                        Text("\(Int((gradientOffsetY / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .blendMode(.hue)
                    }
                    .overlay{
                        Text("\(Int((gradientOffsetY / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                    }
                    .overlay{
                        Text("\(Int((gradientOffsetY / 1000) * 100))%")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .lineLimit(1) // Ensure text doesn't exceed one line
                            .minimumScaleFactor(0.5) // Allow text to scale down to 50% of its original size if needed
                            .frame(width: 50)
                            .foregroundColor(.black)
                            .blendMode(.overlay)
                    }
                
                CustomSlider(value: $gradientOffsetY, inRange: -1000...1000, activeFillColor: .green, fillColor: .blue.opacity(0.5), emptyColor: .gray.opacity(0.2), height: 10) { started in
                    self.gradientOffsetSliderMoved = started // Update the state when the slider is moved
                }
                .frame(width: sliderScale.width * 0.28)
            }
            
            AnimatedButton(action: {
                gradientOffsetX = 0
                gradientOffsetY = 0
            }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
            .foregroundColor(.white)
            .blendMode(.difference)
            .overlay{
                AnimatedButton(action: {
                    gradientOffsetX = 0
                    gradientOffsetY = 0
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .blendMode(.hue)
            }
            .overlay{
                AnimatedButton(action: {
                    gradientOffsetX = 0
                    gradientOffsetY = 0
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .foregroundColor(.white)
                    .blendMode(.overlay)
            }
            .overlay{
                AnimatedButton(action: {
                    gradientOffsetX = 0
                    gradientOffsetY = 0
                }, sfSymbolName: "arrow.counterclockwise.circle", rotationAntiClockwise: true, rotationDegrees: 720, color: .primary, allowRotation: true, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .foregroundColor(.black)
                    .blendMode(.overlay)
            }
            .padding(.leading, 8)
            .offset(y: 12)
            .scaleEffect(0.8)
            .disabled(!gradientOffsetSliderMoved)
            
        }
        .padding(.horizontal)
        .padding(.vertical)
        
    }
}
