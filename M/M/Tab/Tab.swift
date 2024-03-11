//
//  Tab.swift
//  AnimatedSFTabBar
//
//  Created by Balaji Venkatesh on 31/08/23.
//

import SwiftUI

/// Tab's
enum Tab: String, CaseIterable {
    case wallpapers = "rectangle.grid.3x2"
    case mockup = "apps.iphone.badge.plus"
    case creator = "paintbrush"
    case settings = "gearshape"
  //  case news = "newspaper"
    
    var title: String {
        switch self {
        case .wallpapers:
            return "Walls"
        case .mockup:
            return "Mockup"
        case .creator:
            return "Creator"
        case .settings:
            return "Settings"

        }
    }
}

/// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
