//
//  ProgressBar.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.secondary.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Rectangle()
                    .foregroundColor(.blue.opacity(0.4))
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
            }
            .cornerRadius(100)
        }
    }
}
