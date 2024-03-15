//
//  Home.swift
//  AnimatedSFTabBar
//
//  Created by Balaji Venkatesh on 31/08/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
