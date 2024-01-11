//
//  WidgySwitchView.swift
//  M
//
//  Created by Sean Kelly on 03/01/2024.
//

import SwiftUI

struct WidgySwitchView: View {
    @State private var isTapped: Bool = false
    let bindingValue: Binding<Bool>
    
    var body: some View {
        Button {
            isTapped.toggle()
            bindingValue.wrappedValue.toggle()
            
        } label: {
            
            if isTapped {
             
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                  
            } else {
             
                Image("widgy")
                    .resizable()
                    .colorMultiply(.black)
            }
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .tint(.primary)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .stroke(.primary, lineWidth: 2.5)
                .frame(width: 27, height: 27)
        )
        .frame(width: 20, height: 20)

    }
}

