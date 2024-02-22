//
//  UltraThinButton.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct UltraThinButton: View {
    
    var action: () -> Void
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    let systemName: String
    let gradientFill: Bool
    let fillColor: Color
    let showUltraThinMaterial: Bool
    let useSystemImage: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: gradientFill ? colors : [fillColor]), center: .center)
                )
                .frame(width: 30, height: 30)
                .overlay {
                    if useSystemImage {
                        Image(systemName: systemName)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(x: 2.4, y: 2.4)
                            .foregroundColor(.white)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial.opacity(showUltraThinMaterial ? 1 : 0))
                .clipShape(Circle())
        }
    }
}
