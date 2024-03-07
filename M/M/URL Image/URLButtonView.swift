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
    
    var body: some View {
        VStack {
            ZStack {
                //MARK: Red XButton & Image Count
                /*
                HStack {
                    Button {
//                        isTapped.toggle()
//                        withAnimation(.bouncy) {
//                            showCount = false
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                            obj.appearance.showWallpapersView.toggle()
//                        }
                    } label: {
                        HStack{
                            Circle()
                                .fill(.blue.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "number")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .foregroundColor(.white)
                                }
                            
                            if showCount {
                                if viewModelData.images.count != 0 {
                                    Text("\(formattedCount(viewModelData.images.count))")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .lineLimit(1)
                                        .padding(.horizontal, 5)
                                        .tint(.primary)
                                }
                            }
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    
                    //MARK: Open graidient wall view button
//                    if viewModelData.images.count != 0 {
//                        UltraThinButton(action: {
//                            isShowingGradientView.toggle()
//                        }, systemName: "paintbrush", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
//                        .scaleEffect(buttonScale ? 1 : 0)
//                        .animation(.linear(duration: 0.5), value: buttonScale)
//                        .onAppear{
//                            buttonScale.toggle()
//                        }
//                    }
                    
                    Spacer()
                }
                 */
                                
                //MARK: URL Pill view showing wallpapewr creators
                URLPill(obj: obj, viewModelData: viewModelData)
            }
            .sensoryFeedback(.selection, trigger: isTapped)
            .padding(.horizontal)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.bouncy) {
                        showCount = true
                    }
                }
            }
            
            WallpaperCountView(obj: obj, viewModelData: viewModelData)
            
         // WallpaperTitleView(viewModelData: viewModelData)
            
        }
//        .fullScreenCover(isPresented: $isShowingGradientView) {
//            GradientView(isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground, activeTab: $activeTab)
//        }
    }
}




