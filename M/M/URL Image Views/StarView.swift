//
//  StarView.swift
//  M
//
//  Created by Sean Kelly on 05/12/2023.
//

import SwiftUI


struct StarView: View {

    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 16, weight: .regular))
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

struct WidgyView: View {

    var body: some View {
        VStack {
            HStack {
                
              Image("widgy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .offset(y: 1)
                  
                Spacer()
                
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
