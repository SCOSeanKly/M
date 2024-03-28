//
//  HeaderButtons.swift
//  M
//
//  Created by Sean Kelly on 28/03/2024.
//

import SwiftUI

import SwiftUI

struct HeaderButtons: View {
    
    @ObservedObject var obj: Object
    @State private var isTapped: Bool = false
    
    
    var body: some View {
        VStack {
            ZStack {
                WallpaperButtonView(text: "Shop", subText: "Premium Wallpaper collections and Widgys", obj: obj)
                
                Pill(obj: obj, isTapped: $isTapped)
            }
            
            Spacer()
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .padding(.top, 45)
        .ignoresSafeArea()
    }
}

private struct Pill: View {
    
    @StateObject var obj: Object
    @Binding var isTapped: Bool
    
    
    var body: some View {
        
        HStack {
            Spacer()
            ZStack(alignment: .leading) {
                HStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 30, height: 30)
                        .overlay {
                            ZStack {
                                MenuButton()
                                    .opacity(obj.appearance.showPill ? 1 : 0)
                                
                                CloseButton()
                                    .opacity(obj.appearance.showPill ? 0 : 1)
                            }
                        }
                        .overlay(alignment: .leading) {
                            
                            ZStack(alignment: .leading) {
                                
                                TextViewTwo(obj: obj)
                                    .opacity(obj.appearance.showPill ? 0 : 1)
                            }
                            .padding(.leading, 38)
                        }
                    
                    if !obj.appearance.showPill {
                        
                        TextViewTwoSizer()
                    }
                }
                .onTapGesture {
                    isTapped.toggle()
                    obj.appearance.showPill.toggle()
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .animation(.bouncy, value: obj.appearance.showPill)
            }
        }
        .padding()
    }
}

private struct TextViewTwo: View {
    
    @StateObject var obj: Object
    
    var body: some View {
        Group {
            HStack {
                
                MockupButton(action: {
                    //MARK: ADD FUNCTION
                    
                    obj.appearance.showPill.toggle()
                    
                }, sfSymbolName: "iphone.gen2.circle", showOverlaySymbol: true, overlaySymbolName: "xmark.circle.fill", overlaySymbolColor: .red)
                .padding(.leading, 5)
                
                MockupButton(action: {
                    //MARK: ADD FUNCTION
                    
                    obj.appearance.showPill.toggle()
                    
                }, sfSymbolName: "iphone.gen2.circle", showOverlaySymbol: true, overlaySymbolName: "xmark.circle.fill", overlaySymbolColor: .red)
            }
        }
    }
}

private struct TextViewTwoSizer: View {
    var body: some View {
        Group {
            Color.clear
                .frame(width: 80, height: 30, alignment: .center)
        }
    }
}

private struct MenuButton: View {
    var body: some View {
        Circle()
            .fill(.blue.opacity(0.5))
            .frame(width: 30, height: 30)
            .overlay {
                Image(systemName: "line.3.horizontal.circle")
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundColor(.white)
            }
    }
}

private struct CloseButton: View {
    var body: some View {
        Circle()
            .fill(.red)
            .frame(width: 30, height: 30)
            .overlay {
                Image(systemName: "xmark.circle")
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundColor(.white)
            }
    }
}

private struct WallpaperButtonView: View {
    let text: String
    let subText: String
    @StateObject var obj: Object
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                
                Text(text)
                    .font(.largeTitle.bold())
                
                Text(subText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
        }
        .opacity(obj.appearance.showPill ? 1: 0)
        .offset(x: obj.appearance.showPill ?  0 : -100)
        .animation(.bouncy, value: obj.appearance.showPill)
        .padding()
    }
    
    
    
    
}

#Preview {
    HeaderButtons(
        obj: Object()
    )
}



