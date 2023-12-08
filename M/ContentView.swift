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

    
    var body: some View {
        if obj.appearance.showWallpapersView {
            
            // MARK: Wallpaper View
            URLImages(viewModelContent: viewModel, obj: obj)
                .onAppear {
                    let _ = IAP.shared
                }
             
            
        } else {
            
            //MARK: Mockup View
            MockupView(viewModel: viewModel, obj: obj)
                .onAppear {
                    let _ = IAP.shared
                }
        }
    }
    
}

