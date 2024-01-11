//
//  MApp.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct Custom_MockupApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(obj: Object())
                .onAppear {
                    let _ = IAP.shared
                }
              
        }
    }
}
