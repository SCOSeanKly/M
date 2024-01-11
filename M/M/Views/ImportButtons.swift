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
    @State private var isTapped: Bool = false
    let showWallpaperTip = NewWallpapersSectionTip()
    
  
    var body: some View {
        VStack {
            HStack {
                HStack {
                    
                    Group { //MARK: Show Wallpaper Button
                        Button {
                            
                            isTapped.toggle()
                            withAnimation(.bouncy) {
                                obj.appearance.showPill = true
                            }
                            obj.appearance.showWallpapersView.toggle()
                            showWallpaperTip.invalidate(reason: .actionPerformed)
                            
                        } label: {
                            Circle()
                                .fill(.blue.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "photo.circle")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .foregroundColor(.white)
                                }
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                    
                    Group { //MARK: Show Application Settings
                        Button {
                            
                            isTapped.toggle()
                            withAnimation(.bouncy) {
                                obj.appearance.showPill = true
                            }
                            obj.appearance.showApplicationSettings.toggle()
                          
                        } label: {
                            Circle()
                                .fill(.blue.opacity(0.5))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "gearshape")
                                        .font(.system(.body, design: .rounded).weight(.medium))
                                        .foregroundColor(.white)
                                }
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                }
                .opacity(obj.appearance.showPill ? 1: 0)
                .offset(x: obj.appearance.showPill ?  0 : -100)
                .pillModifier(obj: obj, normalScale: 1)
                
                Spacer()
                
                Pill(
                    viewModel: viewModel, obj: obj, saveCount: $saveCount
                )
            }
            .padding()
            .sensoryFeedback(.selection, trigger: isTapped)
            
            Spacer()
        }
 
    }
}

private struct Pill: View {
    
    @StateObject var viewModel:  ContentViewModel
    @StateObject var obj: Object
    @Binding var saveCount: Int
    @State private var isTapped: Bool = false
    @State private var isTappedProminent: Bool = false
    
    
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
                            
                            TextViewTwo(obj: obj, viewModel: viewModel)
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
            .sensoryFeedback(.success, trigger: isTappedProminent)
            .onTapGesture {
                withAnimation(.bouncy){
                    isTapped.toggle()
                    obj.appearance.showPill.toggle()
                }
            }
            .padding(8)
            .padding(.trailing, 4)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .pillModifier(obj: obj, normalScale: 1.0)
        }
      
    }
}

private struct TextViewOne: View {
    @Binding var saveCount: Int
    var body: some View {
        
        
        RollingText(value: $saveCount)
        /*
        Text("\(saveCount)")
            .font(.system(.body, design: .rounded).weight(.medium))
         */
        
        
    }
}

private struct TextViewOneSizer: View {
    @Binding var saveCount: Int
    var body: some View {
        VStack {
            Text("\(saveCount)")
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundColor(.clear)
        }
    }
}

private struct TextViewTwo: View {
    
    @StateObject var obj: Object
    @StateObject var viewModel: ContentViewModel

    
  
    
    var body: some View {
        Group {
            
            HStack {
                    AnimatedButton(action: {
                        
                        viewModel.showImagePickerSheet1 = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "iphone.gen2.circle", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedImage1 == nil ? "1.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedImage1 == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    .padding(.leading, 5)
                    
                    AnimatedButton(action: {
                        
                        viewModel.showImagePickerSheet2 = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "iphone.gen2.circle", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedImage2 == nil ? "2.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedImage2 == nil ? .primary : .red)
                    
                    AnimatedButton(action: {
                        
                        viewModel.showBgPickerSheet = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "photo.circle", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedBackground == nil ? "plus.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedBackground == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    
                    AnimatedButton(action: {
                        
                        viewModel.showLogoPickerSheet = true
                        withAnimation(.bouncy){
                            obj.appearance.showPill.toggle()
                        }
                        
                    }, sfSymbolName: "person.circle", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: true, overlaySymbolName: viewModel.importedLogo == nil ? "plus.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedLogo == nil ? .primary : .red)
                    .padding(.horizontal, 5)
                    
                    Divider()
                    
                    AnimatedButton(action: {
                        obj.appearance.showSettingsSheet.toggle()
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.bouncy){
                                obj.appearance.showPill.toggle()
                            }
                        }
                    }, sfSymbolName: "slider.horizontal.3", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                    .padding(.horizontal, 5)
            }
        }
    }
}

private struct TextViewTwoSizer: View {
    @StateObject var obj: Object
    var body: some View {
        Group {
            Color.clear
                .frame(width: obj.appearance.showAppSettings ? 80 : 215, height: 30, alignment: .center)
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

