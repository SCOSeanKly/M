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
    
    var currentYear: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        return "\(year)"
    }
    

    var body: some View {
      
            VStack {
                
                Link("© ShowCreative \(currentYear)", destination: showCreativeURL)
                
                HStack {
                    Text("Ver: \(Bundle.main.appVersion!)")
                    Text("Build: \(Bundle.main.buildNumber!)")
                }
                .foregroundColor(.gray)
                
                    Text("UIDevice: \(UIDevice.current.modelName)")
                        .foregroundColor(.gray)
                        .font(.system(size: 10)) 
                
            }
            .font(.footnote)
            .padding(.vertical)
         
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy" // Set custom date format
        return formatter
    }()
}

