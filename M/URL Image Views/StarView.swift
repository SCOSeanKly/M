//
//  StarView.swift
//  M
//
//  Created by Sean Kelly on 05/12/2023.
//

import SwiftUI


struct StarView: View {
    
    let text: String
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Image(systemName: "star.square")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
            }
            .padding()
            
            Spacer()
        }
    }
}

