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
    
    var body: some View {
        if obj.appearance.showWallpapersView {
            
            // MARK: Wallpaper View
            URLImages(obj: obj)
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

