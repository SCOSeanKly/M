//
//  FormatWalpaperCount.swift
//  M
//
//  Created by Sean Kelly on 23/11/2023.
//

import SwiftUI


// MARK: Converts 1100 to 1.1K etc
func formattedCount(_ count: Int) -> String {
    if count < 1000 {
        return "\(count)"
    } else {
        let formattedCount = Double(count) / 1000.0
        return String(format: "%.2fK", formattedCount)
    }
}

