//
//  CreatorPlaceholder.swift
//  M
//
//  Created by Sean Kelly on 20/03/2024.
//

import SwiftUI

struct CreatorPlaceholder: View {
    
    @State private var shine: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: 30, height: 30)
                 .clipShape(Circle())
                 .shine(shine, duration: 1, clipShape: Circle())
                 .onAppear {
                     // Start a timer to toggle shine every 2 seconds
                     Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                         shine.toggle()
                     }
                 }
                 .opacity(0.5)
        }
    }
}

#Preview {
    CreatorPlaceholder()
}
