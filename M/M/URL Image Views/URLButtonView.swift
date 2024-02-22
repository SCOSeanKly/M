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
    @Environment(\.openURL) var openURL
    @Binding var isShowingGradientView: Bool
    
    let showCreativeURL = URL(string: "https://twitter.com/SeanKly")!
    let timetravelr2025URL = URL(string: "https://twitter.com/timetravelr2025")!
    let elijahCreativeURL = URL(string: "https://twitter.com/ElijahCreative")!
    let patricialeveqURL = URL(string: "https://twitter.com/patricialeveq")!
    //let RealStellaSkyURL = URL(string: "https://realstellasky.com/resources")!
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    @State private var buttonScale: Bool = false
    
    var body: some View {
        
        
        VStack {
            //MARK: Buttons
            Group {
                ZStack {
                    HStack {
                        //MARK: Red XButton
                        Group {
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
                            .opacity(obj.appearance.showPill ? 1: 0)
                            .offset(x: obj.appearance.showPill ?  0 : -100)
                        }
                        
                        //MARK: Open graidient wall view
                        Group {
                            if viewModelData.images.count != 0 {
                                UltraThinButton(action: {
                                    isTapped.toggle()
                                    isShowingGradientView.toggle()
                                }, systemName: "paintbrush", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true)
                                .opacity(obj.appearance.showPill ? 1: 0)
                                .offset(x: obj.appearance.showPill ?  0 : -100)
                                .scaleEffect(buttonScale ? 1 : 0)
                                .animation(.linear(duration: 0.5), value: buttonScale)
                                .onAppear{
                                    buttonScale.toggle()
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        URLPill(obj: obj, viewModelData: viewModelData)
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
            }
            
            //MARK: Wallpapers view
            Group {
                HStack {
                    Text(viewModelData.creatorName == "widgy" ? "Widgets" : "Wallpapers")
                        .font(.largeTitle.bold())
                        .onChange(of: viewModelData.creatorName) {
                            viewModelData.forceRefresh.toggle()
                        }
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                
                HStack(spacing: 0) {
                    if viewModelData.creatorName == "widgy" {
                        Text("A collection of premium widgy widgets")
                    } else {
                        Text("Premium wallpapers by ")
                        
                        Text("@\(viewModelData.creatorName)")
                            .fontWeight(.bold)
                            .onTapGesture {
                                switch viewModelData.creatorName {
                                case "SeanKly":
                                    openURL(showCreativeURL)
                                case "timetravelr2025":
                                    openURL(timetravelr2025URL)
                                    //case "RealStellaSky":
                                    //openURL(RealStellaSkyURL)
                                case "ElijahCreative":
                                    openURL(elijahCreativeURL)
                                case "patricialeveq":
                                    openURL(patricialeveqURL)
                                default:
                                    break
                                }
                            }
                    }
                    
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $isShowingGradientView) {
            GradientView(isShowingGradientView: $isShowingGradientView)
        }
        
    }
}

struct UltraThinButton: View {
    
    var action: () -> Void
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
    let systemName: String
    let gradientFill: Bool
    let fillColor: Color
    let showUltraThinMaterial: Bool
    let useSystemImage: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: gradientFill ? colors : [fillColor]), center: .center)
                )
                .frame(width: 30, height: 30)
                .overlay {
                    if useSystemImage {
                        Image(systemName: systemName)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(x: 2.4, y: 2.4)
                            .foregroundColor(.white)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial.opacity(showUltraThinMaterial ? 1 : 0))
                .clipShape(Circle())
        }
    }
}


