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
    
    @ObservedObject var viewModel = DataViewModel()
    
    var totalFilesCount: Int {
        if obj.appearance.showPremiumWallpapersOnly {
            // Count only images with "p_" in the name
            return viewModel.images.filter { $0.image.contains("p_") }.count
        } else {
            // Count all images
            return viewModel.images.count
        }
    }

    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    
    
    var body: some View {
        HStack {
            Button {
                
                isTapped.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    withAnimation(.bouncy) {
                        showCount = false
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
                
                Image(systemName: "star.square")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                
                Text("Premium")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
            }
            
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .padding()
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.bouncy) {
                    showCount = true
                }
            }
        }
        .onDisappear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.bouncy) {
                    showCount = false
                }
            }
        }
        
        VStack {
            HStack {
                Text("Wallpapers")
                    .font(.largeTitle.bold())
                
                Spacer()
                /*
                CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.showPremiumWallpapersOnly, onSymbol: "star", offSymbol: "line.3.horizontal.decrease", rotate: false, onColor: .yellow, offColor: .gray, obj: obj)
                */
            }
            .padding(.horizontal)
            
            HStack {
                Text("A collection of premium wallpapers")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}
