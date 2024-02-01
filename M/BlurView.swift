//
//  BlurView.swift
//  M
//
//  Created by Sean Kelly on 29/12/2023.
//

import SwiftUI

struct BlurView: View {
    var body: some View {
        
        ZStack {
            Text("HELLO")
                .font(.largeTitle)
            
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.clear)
                .background {
                    TransparentBlurView(removeAllFilters: true)
                        .blur(radius: 15, opaque: true)
                }
                .clipShape(Rectangle())
              
        }
        .ignoresSafeArea()
        
      
          
    }
}


#Preview {
    BlurView()
}
