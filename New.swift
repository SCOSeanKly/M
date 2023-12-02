//
//  New.swift
//  M
//
//  Created by Sean Kelly on 02/12/2023.
//

import SwiftUI

struct New: View {
    var body: some View {
        Text("NEW")
            .font(.system(size: 10))
            .foregroundColor(.primary)
            .padding(4)
            .background(Color.primary.colorInvert())
            .cornerRadius(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                 .stroke(Color.primary.opacity(0.4), lineWidth: 0.5)
               
                
                 .shadow(color: .black.opacity(0.4), radius: 1, y: 1)
            )
            .padding()

    }
}

#Preview {
    New()
}
