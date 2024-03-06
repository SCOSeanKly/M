//
//  NewsView.swift
//  M
//
//  Created by Sean Kelly on 04/03/2024.
//

import SwiftUI

struct NewsView: View {
    
    @Binding var showNewDataAlert: Bool
    @Binding var updates: [Update]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    UltraThinButton(action: {
                        showNewDataAlert.toggle()
                    }, systemName: "xmark", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                   
                    
                    Text("News")
                        .font(.title)
                    
                    Spacer()
                }
                .padding()
                
                
                List(updates) { update in
                    VStack(alignment: .leading) {
                        Text(update.title)
                            .font(.headline)
                        Text(update.content)
                            .font(.body)
                    }
                }
            }
        }
    }
}


struct Update: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let content: String
}
