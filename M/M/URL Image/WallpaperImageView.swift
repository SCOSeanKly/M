//
//  WallpaperImageView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct WallpaperImageView: View {
    var imageURL: URL
    var isPremium: Bool
    var isNew: Bool
    var onTap: () -> Void
    var obj: Object
    @Binding var premiumRequiredAlert: AlertConfig
    
    var body: some View {
        VStack {
            WebImage(url: imageURL)
                .resizable()
                .customFrameBasedOnCondition(obj: obj)
                .overlay {
                    if isPremium {
                        CrownOverlayView()
                    }

                    if isNew {
                        NewWallAddedView()
                            .customFrameBasedOnCondition(obj: obj)
                    }
                }
                .onTapGesture {
                    onTap()
                }
                .alert(alertConfig: $premiumRequiredAlert) {
                    alertPreferences(title: "Premium Required!", imageName: "crown.fill")
                }

            let fileName = getFileName(from: imageURL.absoluteString)

            FileNameView(fileName: fileName)
        }
    }
    
    private func getFileName(from urlString: String) -> String {
        if let url = URL(string: urlString) {
            return url.deletingPathExtension().lastPathComponent
        }
        return ""
    }
    
    private func alertPreferences(title: String, imageName: String) -> some View {
        VStack {
            
            Text("\(Image(systemName: imageName)) \(title)")
            
            Text("Open settings to unlock premium")
                .font(.system(size: 12, design: .rounded))
                .padding(.top, 5)
            
        }
        .foregroundStyle(.black)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.yellow)
        }
    }
}
