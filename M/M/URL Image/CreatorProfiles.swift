//
//  creatorProfiles.swift
//  M
//
//  Created by Sean Kelly on 16/01/2024.
//

import SwiftUI
import SwiftUIX

struct CreatorProfiles: View {
    
    @StateObject var obj: Object
    @Environment(\.openURL) var openURL
    
    // Dictionary to map avatar names to their corresponding URLs
    let avatarURLs: [String: URL] = [
        "SeanKly": URL(string: "https://twitter.com/SeanKly")!,
        "timetravelr2025": URL(string: "https://twitter.com/timetravelr2025")!,
        "ElijahCreative": URL(string: "https://twitter.com/ElijahCreative")!,
        "widgy": URL(string: "https://www.reddit.com/r/widgy/")!,
        "patricialeveq": URL(string: "https://twitter.com/patricialeveq")!,
        "SmartWallpaperArt": URL(string: "https://twitter.com/TeboulDavid1")!
    ]
    
    @State private var isButtonTapped: Bool = false
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(obj.appearance.avatarNames, id: \.self) { avatarName in
                    if let url = avatarURLs[avatarName] {
                        Button {
                            openURL(url)
                            isButtonTapped.toggle()
                        } label: {
                            VStack {
                                Image(avatarName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding(.top)
                                
                                Image(avatarName == "widgy" ? "reddit" : "twitter")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                    .offset(x: 10.0, y: -20)
                                
                                Text(avatarName)
                                    .font(.system(size: 8, weight: .regular, design: .rounded))
                                    .offset(y: -15)
                            }
                        }
                        .frame(width: 78, height: 90)
                        .buttonStyle(.plain)
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: isButtonTapped)
        }
    }
}


