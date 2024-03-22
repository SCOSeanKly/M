//
//  WallpaperTitleView.swift
//  M
//
//  Created by Sean Kelly on 07/03/2024.
//

import SwiftUI

struct WallpaperCountView: View {
    @StateObject var obj: Object
    @StateObject var viewModelData: DataViewModel
    @Environment(\.openURL) var openURL
    let showCreativeURL = URL(string: "https://twitter.com/SeanKly")!
    let timetravelr2025URL = URL(string: "https://twitter.com/timetravelr2025")!
    let elijahCreativeURL = URL(string: "https://twitter.com/ElijahCreative")!
    let patricialeveqURL = URL(string: "https://twitter.com/patricialeveq")!
    let SmartWallpaperArtURL = URL(string: "https://twitter.com/TeboulDavid1")!
    
    var body: some View {
     
            HStack(spacing: 0) {
                if viewModelData.creatorName == "widgy" {
                    
                    if viewModelData.images.count != 0 {
                        Text("\(formattedCount(viewModelData.images.count))")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                           
                    } else {
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                    
                    Text(
                        " premium widgy widgets")
                } else {
                    if viewModelData.images.count != 0 {
                    Text("\(formattedCount(viewModelData.images.count))")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    } else {
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                    
                    Text(" Wallpapers by ")
                    
                    Text("@\(viewModelData.creatorName)")
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.gray)
            .padding(.leading)
            .padding(.top, -20)
            .opacity(obj.appearance.showPill ? 1: 0)
            .offset(x: obj.appearance.showPill ?  0 : -100)
           
        
    }
}
