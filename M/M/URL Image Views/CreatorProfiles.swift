//
//  creatorProfiles.swift
//  M
//
//  Created by Sean Kelly on 16/01/2024.
//

import SwiftUI

struct CreatorProfiles: View {
    
    @StateObject var obj: Object
    @Environment(\.openURL) var openURL
    
    let showCreativeURL = URL(string: "https://twitter.com/SeanKly")!
    let timetravelr2025URL = URL(string: "https://twitter.com/timetravelr2025")!
    let elijahCreativeURL = URL(string: "https://twitter.com/ElijahCreative")!
    let widgyURL = URL(string: "https://www.reddit.com/r/widgy/")!
    let patricialeveqURL = URL(string: "https://twitter.com/patricialeveq")!
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(obj.appearance.avatarNames, id: \.self) { avatarName in
                    Button {
                        switch avatarName {
                        case "SeanKly":
                            openURL(showCreativeURL)
                        case "timetravelr2025":
                            openURL(timetravelr2025URL)
                        case "ElijahCreative":
                            openURL(elijahCreativeURL)
                        case "patricialeveq":
                            openURL(patricialeveqURL)
                        case "widgy":
                            openURL(widgyURL)
                        default:
                            break
                        }
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
                            
                            Text(avatarName == "widgy" ? "r/\(avatarName)" : "@\(avatarName)")
                                .font(.system(size: 8, weight: .regular, design: .rounded))
                                .offset(y: -15)
                        }
                    }
                }
                .frame(width: 78, height: 90)
                .buttonStyle(.plain)
            }
        }
      
    }
}

struct CreatorProfiles_Previews: PreviewProvider {
    static var previews: some View {
        CreatorProfiles(obj: Object())
    }
}
