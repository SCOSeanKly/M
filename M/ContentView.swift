//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var obj: Object
    @State private var totalNewWallpapersCount = 0
    
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = true
    @State var buyClicked: Bool = false

    
    var body: some View {
        if obj.appearance.showWallpapersView {
            
            // MARK: Wallpaper View
            URLImages(viewModelContent: viewModel, obj: obj, showPremiumContent: $showPremiumContent)
                .onAppear {
                    let _ = IAP.shared
                }
             
        } else {
            
            //MARK: Mockup View
            MockupView(viewModel: viewModel, obj: obj, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked)
                .onAppear {
                    let _ = IAP.shared
                }
        }
    }
    
}

