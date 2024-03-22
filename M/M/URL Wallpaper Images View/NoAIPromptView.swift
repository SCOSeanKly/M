//
//  NoAIPromptView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

struct NoAIPromptView: View {
    @Binding var isNoAIPromptVisible: Bool
    @Binding var isNoAIPromptVisibleAnimation: Bool
    
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
            
            Text("No AI prompt in meta data")
            
        }
        .modifier(AICustomTextModifier(customPadding: 7.8, cornerRadius: 50, strokeOpacity: 0.0))
        .onAppear {
            // Show the text and schedule its hiding
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                isNoAIPromptVisible = false
                isNoAIPromptVisibleAnimation.toggle()
            }
        }
        .animation(.easeInOut, value: isNoAIPromptVisibleAnimation)
    }
}
