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
        return viewModel.images.count
    }
    
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
                    obj.appearance.showWallpapers.toggle()
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
                        Text("\(formattedCount(totalFilesCount))")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .padding(.horizontal, 5)
                            .tint(.primary)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
          
            
            Spacer()
             
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
        
        HStack {
            Text("Wallpapers")
                .font(.largeTitle.bold())
            
            Spacer()
            
        }
        .padding(.horizontal)
        
        HStack {
            Text("A collection of wallpapers")
                .foregroundStyle(.gray)
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}
