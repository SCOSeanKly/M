//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var viewModelData = DataViewModel()
    @StateObject var obj: Object
    @State private var totalNewWallpapersCount = 0
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    
    @State var buyClicked: Bool = false
    let animationDuration: CGFloat = 0.2

    
    var body: some View {
   
        Group {
            ZStack {
                if obj.appearance.showWallpapersView {
                    
                    // MARK: Wallpaper View
                    GeometryReader { geometry in
                        URLImages(viewModelData: viewModelData, viewModelContent: viewModel, obj: obj, showPremiumContent: $showPremiumContent)
                            .opacity(geometry.frame(in: .global).midX >= UIScreen.main.bounds.width / 2 ? 1.0 : 0.0)
                            .onAppear {
                                let _ = IAP.shared
                            }
                            .rotation3DEffect(
                                Angle(degrees: obj.appearance.showWallpapersView ? -180 : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
                    }
                    
                } else {
                    
                    //MARK: Mockup View
                    GeometryReader { geometry in
                        MockupView(viewModel: viewModel, obj: obj, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked)
                            .opacity(geometry.frame(in: .global).midX <= UIScreen.main.bounds.width / 2 ? 1.0 : 0.0)
                            .onAppear {
                                let _ = IAP.shared
                            }
                            .rotation3DEffect(
                                Angle(degrees: obj.appearance.showWallpapersView ? 180 : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
                    }
                }
            }
            .rotation3DEffect(
                Angle(degrees: obj.appearance.showWallpapersView ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
        }
    
    }
}
