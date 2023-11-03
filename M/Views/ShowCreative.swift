//
//  ShowCreative.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct ShowCreative: View {
    @Environment(\.openURL) var openURL
    
    let showCreativeURL = URL(string: "https://twitter.com/SeanKly")!
 
    var body: some View {
        ZStack {
   
            VStack {
                Link("© ShowCreative 2024", destination: showCreativeURL)
                
                HStack {
                    Text("Ver. \(Bundle.main.appVersion!)")
                    Text("Build. \(Bundle.main.buildNumber!)")
                }
                .foregroundColor(.gray)
                
            }
            .font(.footnote)
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(0.8)
        
        Spacer()
        
        Spacer()
            .frame(height: 50)
    }
}
