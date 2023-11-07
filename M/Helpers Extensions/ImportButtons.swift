//
//  ImportButtons.swift
//  M
//
//  Created by Sean Kelly on 06/11/2023.
//

import SwiftUI

struct importButtons: View {
    
    @State private var isAnimationSlowed = false
    @StateObject var obj: Object
    @Binding var saveCount: Int
    @StateObject var viewModel:  ContentViewModel
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Pill(
                    viewModel: viewModel, obj: obj, saveCount: $saveCount, isDarkMode: $isDarkMode
                )
            }
            .padding()
            
            Spacer()
            
        }
    }
}

private struct Pill: View {
    
    
    @StateObject var viewModel:  ContentViewModel
    @StateObject var obj: Object
    @Binding var saveCount: Int
    @Binding var isDarkMode: Bool
    @State private var isTapped: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                
                Circle()
                    .fill(.clear)
                    .frame(width: 30, height: 30)
                    .overlay {
                        ZStack {
                            ViewerCountIcon()
                                .opacity(obj.appearance.showPill ? 1 : 0)
                            
                            ViewerAvatar()
                                .opacity(obj.appearance.showPill ? 0 : 1)
                        }
                    }
                    .overlay(alignment: .leading) {
                        
                        ZStack(alignment: .leading) {
                            TextViewOne(saveCount: $saveCount)
                                .opacity(obj.appearance.showPill ? 1 : 0)
                            
                            TextViewTwo(obj: obj, viewModel: viewModel, isDarkMode: $isDarkMode)
                                .opacity(obj.appearance.showPill ? 0 : 1)
                        }
                        .frame(width: 200, alignment: .leading)
                        .padding(.leading, 38)
                    }
                
                
                if obj.appearance.showPill {
                    TextViewOneSizer(saveCount: $saveCount)
                } else {
                    TextViewTwoSizer(obj: obj)
                }
            }
            .sensoryFeedback(.selection, trigger: isTapped)
            .onTapGesture {
                withAnimation(.bouncy){
                    isTapped.toggle()
                    obj.appearance.showPill.toggle()
                    obj.appearance.showAppSettings = false
                }
            }
            .onLongPressGesture(minimumDuration: 0.5){
                if !obj.appearance.showPill {
                    withAnimation(.bouncy){
                        obj.appearance.showAppSettings.toggle()
                        isTapped.toggle()
                    }
                }
            }
        }
        .padding(8)
        .padding(.trailing, 4)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

private struct TextViewOne: View {
    @Binding var saveCount: Int
    var body: some View {
        Text("\(saveCount)")
            .font(.system(.body, design: .rounded).weight(.medium))
    }
}

private struct TextViewOneSizer: View {
    @Binding var saveCount: Int
    var body: some View {
        Text("\(saveCount)")
            .font(.system(.body, design: .rounded).weight(.medium))
            .foregroundColor(.clear)
    }
}

private struct TextViewTwo: View {
    
    @StateObject var obj: Object
    @StateObject var viewModel: ContentViewModel
    @Binding var isDarkMode: Bool
    
    var symbolName: String {
           switch obj.appearance.selectedAppearance {
           case .light:
               return "sun.max"
           case .dark:
               return "moon"
           case .system:
               return "rays"
           }
       }
    
    var body: some View {
        Group {
            
            HStack {
                
                if !obj.appearance.showAppSettings {
                    
                    AnimatedButton(action: {
                        
                        viewModel.showImagePickerSheet1 = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "iphone.gen2.circle", rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedImage1 == nil ? "plus.circle" : "xmark.circle", overlaySymbolColor: viewModel.importedImage1 == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    .padding(.leading, 5)
                    
                    
                    AnimatedButton(action: {
                        
                        viewModel.showBgPickerSheet = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "photo.circle", rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedBackground == nil ? "plus.circle" : "xmark.circle", overlaySymbolColor: viewModel.importedBackground == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    
                    AnimatedButton(action: {
                        
                        viewModel.showLogoPickerSheet = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "person.circle", rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedLogo == nil ? "plus.circle" : "xmark.circle", overlaySymbolColor: viewModel.importedLogo == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    
                    Divider()
                    
                    
                    AnimatedButton(action: {
                        obj.appearance.showSettingsSheet.toggle()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.bouncy){
                                obj.appearance.showPill.toggle()
                            }
                        }
                    }, sfSymbolName: "slider.horizontal.3", rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.horizontal, 5)
                } else {
                    
                    AnimatedButton(action: {
                        
                        obj.appearance.enableImportTapGestures.toggle()
                        
                    }, sfSymbolName: obj.appearance.enableImportTapGestures ? "hand.tap" : "hand.raised.slash", rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.horizontal, 5)
                    .padding(.leading, 5)
                   
                    
                    
                    AnimatedButton(action: {
                        
                       // isDarkMode.toggle()
                        
                        switch obj.appearance.selectedAppearance {
                          case .system:
                              obj.appearance.selectedAppearance = .light
                          case .light:
                              obj.appearance.selectedAppearance = .dark
                          case .dark:
                              obj.appearance.selectedAppearance = .system
                          }
                        
                    }, sfSymbolName: symbolName, rotationAntiClockwise: false, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.horizontal, 5)
                    
                }
            }
        }
    }
}

private struct TextViewTwoSizer: View {
    @StateObject var obj: Object
    var body: some View {
        Group {
            Color.clear
                .frame(width: obj.appearance.showAppSettings ? 80 : 180, height: 30, alignment: .center)
        }
    }
}

private struct ViewerCountIcon: View {
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

private struct ViewerAvatar: View {
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

