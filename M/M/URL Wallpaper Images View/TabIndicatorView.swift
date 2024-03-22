//
//  TabIndicatorView.swift
//  M
//
//  Created by Sean Kelly on 01/02/2024.
//

import SwiftUI

struct TabIndicatorView: View {
    var body: some View {
      RoundedRectangle(cornerRadius: 50)
            .frame(width: 50, height: 5)
            .foregroundStyle(.primary.opacity(0.5))
    }
}

#Preview {
    TabIndicatorView()
}
