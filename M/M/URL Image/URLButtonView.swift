//
//  URLButtonView.swift
//  M
//
//  Created by Sean Kelly on 22/11/2023.
//





import SwiftUI

struct ButtonView: View {
    
    @State private var isTapped: Bool = false
    @State private var showCount: Bool = false
    @StateObject var obj: Object
    @StateObject var viewModelData: DataViewModel
    @Binding var showPremiumContent: Bool
    @Binding var isShowingGradientView: Bool
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    @State private var buttonScale: Bool = false
    @Binding var importedBackground: UIImage?
    @Binding var activeTab: Tab
    @StateObject var newCreatorsViewModel: NewImagesViewModel
    
    var body: some View {
        VStack {
            ZStack {
                //MARK: URL Pill view showing wallpapewr creators
                URLPill(obj: obj, viewModelData: viewModelData, newCreatorsViewModel: newCreatorsViewModel)
            }
            .sensoryFeedback(.selection, trigger: isTapped)
            .padding(.horizontal)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.snappy) {
                        showCount = true
                    }
                }
            }
            
            WallpaperCountView(obj: obj, viewModelData: viewModelData)
            
         // WallpaperTitleView(viewModelData: viewModelData)
            
        }
    }
}




