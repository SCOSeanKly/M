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
    
    var totalFilesCount: Int {
        if obj.appearance.showWidgetsOnly {
            // Count only images with "w_" in the name
            return viewModelData.images.filter { $0.image.contains("w_") }.count
        } else {
            // Count all images
            return viewModelData.images.count
        }
    }

    @Binding var showPremiumContent: Bool
  

    var body: some View {
        HStack {
            Button {
                
                isTapped.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    withAnimation(.bouncy) {
                        showCount = false
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    obj.appearance.showWallpapersView.toggle()
                }
                
            } label: {
                HStack{
                    Circle()
                        .fill(.red)
                        .frame(width: 30, height: 30)
                        .overlay {
                                Image(systemName: "xmark.circle")
                                    .font(.system(.body, design: .rounded).weight(.medium))
                                    .foregroundColor(.white)
                        }
                      
                    
                    if showCount {
                        if totalFilesCount != 0 {
                            Text("\(formattedCount(totalFilesCount))")
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .padding(.horizontal, 5)
                                .tint(.primary)
                        }
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
          
            Spacer()
            
            if showPremiumContent {
                
                VStack {
                 CrownView()
                       
                    Text("Unlocked")
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.yellow.gradient)
               
            }
            
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .padding()
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.bouncy) {
                    showCount = true
                }
            }
        }
        .onDisappear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.bouncy) {
                    showCount = false
                }
            }
        }
        
        VStack {
            HStack {
                Text(viewModelData.showWidgys ? "Widgets" : "Wallpapers")
                    .font(.largeTitle.bold())
                    .onChange(of: viewModelData.showWidgys) {
                        viewModelData.forceRefresh.toggle()
                    }

                Spacer()
                
                CustomToggle(showTitleText: false, titleText: "", bindingValue: $viewModelData.showWidgys, onSymbol: "diamond", offSymbol: "square", rotate: true, onColor: .mint, offColor: .teal, obj: obj)
               
            }
            .padding(.horizontal)
            
            HStack {
                Text(viewModelData.showWidgys ? "A collection of premium widgets" : "A collection of premium wallpapers")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}


