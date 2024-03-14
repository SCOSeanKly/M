//
//  WallpaperURLS.swift
//  M
//
//  Created by Sean Kelly on 14/03/2024.
//

import SwiftUI

struct WallpaperURLData {
    static let commonBaseUrl = "https://raw.githubusercontent.com/"

    static let creatorURLs: [String: (subPath: String, jsonFile: String)] = [
        "widgy": (
            subPath: "M_Resources/main/Widgys/",
            jsonFile: "M_Resources/main/JSON/widgyImages.json"
        ),
        "SeanKly": (
            subPath: "SCOSeanKly/M_Resources/main/Wallpapers/",
            jsonFile: "SCOSeanKly/M_Resources/main/JSON/wallpaperImages.json"
        ),
        "ElijahCreative": (
            subPath: "ElijahCreative/ElijahCreative_M_Resources/main/Wallpapers/",
            jsonFile: "ElijahCreative/ElijahCreative_M_Resources/main/JSON/elijahCreative.json"
        ),
        "SmartWallpaperArt": (
            subPath: "SmartWallpaperArt/SmartWallpaperArt_M_Resources/main/Wallpapers/",
            jsonFile: "SmartWallpaperArt/SmartWallpaperArt_M_Resources/main/JSON/SmartWallpaperArt.json"
        ),
        "timetravelr2025": (
            subPath: "TimeTraveler_M_Resources/main/Wallpapers/",
            jsonFile: "TimeTraveler_M_Resources/main/JSON/timetravelr2025.json"
        ),
        "patricialeveq": (
            subPath: "patricialeveq/patricialeveq_M_Resources/main/Wallpapers/",
            jsonFile: "patricialeveq/patricialeveq_M_Resources/main/JSON/patricialeveq.json"
        )
    ]
}

