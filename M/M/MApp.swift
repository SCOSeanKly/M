//
//  MApp.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

@main
struct Custom_MockupApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
              MockupMView(obj: Object())
                .onAppear {
                    let _ = IAP.shared
                }
        }
    }
}
