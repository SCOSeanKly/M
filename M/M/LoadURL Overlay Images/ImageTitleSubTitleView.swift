//
//  ImageTitleSubTitleView.swift
//  M
//
//  Created by Sean Kelly on 29/02/2024.
//

import SwiftUI

struct ImageTitleSubTitleView: View {
    let image: ImageModelOverlayImage
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                HStack {
                    Text(image.title)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .blendMode(.difference)
                        .overlay{
                            Text(image.title)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .blendMode(.hue)
                        }
                        .overlay{
                            Text(image.title)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .blendMode(.overlay)
                        }
                        .overlay{
                            Text(image.title)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                                .blendMode(.overlay)
                        }
                    
                    Spacer()
                }
                HStack {
                    Text(image.subtitle)
                        .font(.system(size: 8, weight: .regular, design: .rounded))
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .blendMode(.difference)
                        .overlay{
                            Text(image.subtitle)
                                .font(.system(size: 8, weight: .regular, design: .rounded))
                                .lineLimit(1)
                                .blendMode(.hue)
                        }
                        .overlay{
                            Text(image.subtitle)
                                .font(.system(size: 8, weight: .regular, design: .rounded))
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .blendMode(.overlay)
                        }
                        .overlay{
                            Text(image.subtitle)
                                .font(.system(size: 8, weight: .regular, design: .rounded))
                                .lineLimit(1)
                                .foregroundColor(.black)
                                .blendMode(.overlay)
                        }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}
