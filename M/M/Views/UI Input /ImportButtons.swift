//
//  ImportButtons.swift
//  M
//
//  Created by Sean Kelly on 06/11/2023.
//

import SwiftUI

struct importButtons: View {
    
    @State private var isAnimationSlowed = false
    @ObservedObject var obj: Object
    @Binding var saveCount: Int
    @ObservedObject var viewModel:  ContentViewModel
    @State private var isTapped: Bool = false
    @Binding var isShowingGradientView: Bool
    @ObservedObject var viewModelData: DataViewModel
    @ObservedObject var newCreatorsViewModel: NewImagesViewModel
 
    
    var body: some View {
        VStack {
            ZStack {
                WallpaperButtonView(isTapped: $isTapped, obj: obj, isShowingGradientView: $isShowingGradientView, viewModelData: viewModelData, newCreatorsViewModel: newCreatorsViewModel)
            
                Pill(viewModel: viewModel, obj: obj, saveCount: $saveCount, isTapped: $isTapped)
            }
            
            Spacer()
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .padding(.top, 45)
        .ignoresSafeArea()
    }
}

private struct Pill: View {
    
    @StateObject var viewModel:  ContentViewModel
    @StateObject var obj: Object
    @Binding var saveCount: Int
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
                .onTapGesture {
                        isTapped.toggle()
                        obj.appearance.showPill.toggle()
                }
                .pillModifier(obj: obj, normalScale: 1.0)
            }
        }
        .padding()
    }
}

private struct TextViewOne: View {
    @Binding var saveCount: Int
    var body: some View {
        
        RollingText(value: $saveCount)
 
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
                
                MockupButton(action: {
                    viewModel.showImagePickerSheet1 = true
                 
                        obj.appearance.showPill.toggle()
                    
                }, sfSymbolName: "iphone.gen2.circle", showOverlaySymbol: true, overlaySymbolName: viewModel.importedImage1 == nil ? "1.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedImage1 == nil ? .primary : .red)
                .padding(.leading, 5)
                
                MockupButton(action: {
                    viewModel.showImagePickerSheet2 = true
                  
                        obj.appearance.showPill.toggle()
                   
                }, sfSymbolName: "iphone.gen2.circle", showOverlaySymbol: true, overlaySymbolName: viewModel.importedImage2 == nil ? "2.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedImage2 == nil ? .primary : .red)
              
                MockupButton(action: {
                    viewModel.showBgPickerSheet = true
                   
                        obj.appearance.showPill.toggle()
                
                }, sfSymbolName: "photo.circle", showOverlaySymbol: true, overlaySymbolName: viewModel.importedBackground == nil ? "plus.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedBackground == nil ? .primary : .red)
             
                MockupButton(action: {
                    viewModel.showLogoPickerSheet = true
                 
                        obj.appearance.showPill.toggle()
                
                }, sfSymbolName: "person.circle", showOverlaySymbol: true, overlaySymbolName: viewModel.importedLogo == nil ? "plus.circle" : "xmark.circle.fill", overlaySymbolColor: viewModel.importedLogo == nil ? .primary : .red)
           
                    Divider()
                    
                MockupButton(action: {
                    obj.appearance.showSettingsSheet.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                       
                            obj.appearance.showPill.toggle()
                    
                    }
                }, sfSymbolName: "slider.horizontal.3", showOverlaySymbol: false, overlaySymbolName: "", overlaySymbolColor: .clear)
              
            }
        }
    }
}

private struct TextViewTwoSizer: View {
    @StateObject var obj: Object
    var body: some View {
        Group {
            Color.clear
                .frame(width: obj.appearance.showAppSettings ? 80 : 225, height: 30, alignment: .center)
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

extension View {
    func wallpaperButtonModifier(obj: Object, normalScale: CGFloat) -> some View {
        self
            .opacity(obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings ? 0.3 : 1)
            .animation(.snappy, value: obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings)
            .disabled(obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings)
            .opacity(obj.appearance.showPill ? 1: 0)
            .offset(x: obj.appearance.showPill ?  0 : -100)
            .padding()
    }
}

private struct WallpaperButtonView: View {
    @Binding var isTapped: Bool
    @StateObject var obj: Object
    let showWallpaperTip = NewWallpapersSectionTip()
    @Binding var isShowingGradientView: Bool
    @StateObject var viewModelData: DataViewModel
    @ObservedObject var newCreatorsViewModel: NewImagesViewModel
    @AppStorage("showMagnifyingPromptInt") private var showMagnifyingPromptInt: Int = 0
    
    var body: some View {
            HStack {
                ZStack {
                    Text("Mockup")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .blendMode(.difference)
                    
                    Text("Mockup")
                        .font(.largeTitle.bold())
                        .blendMode(.hue)
                    
                    Text("Mockup")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                    
                    Text("Mockup")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .blendMode(.overlay)
                    
                }
                .font(.largeTitle.bold())
                    .onTapGesture(count: 10) {
                        viewModelData.resetSeenImages()
                        print("viewModelData.resetSeenImages()")
                        resetSeenImages()
                        refreshData()
                        print("refreshData()")
                        feedback()
                        showMagnifyingPromptInt = 0
                        print("showMagnifyingPromptInt reset to: \(showMagnifyingPromptInt)")
                    }
                Spacer()
            }
            .wallpaperButtonModifier(obj: obj, normalScale: 1)
     
    }
    private func refreshData() {
            DispatchQueue.main.async {
                newCreatorsViewModel.reloadData() // Reload data when refresh button is tapped
            }
        }
    
    private func resetSeenImages() {
           for index in newCreatorsViewModel.creators.indices {
               newCreatorsViewModel.creators[index].resetSeenImages()
           }
       }
    
}

extension View {
    func pillModifier(obj: Object, normalScale: CGFloat) -> some View {
        self
            .padding(8)
            .padding(.trailing, 4)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .opacity(obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings ? 0.3 : 1)
            .animation(.bouncy, value: obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings || obj.appearance.showPill)
            .disabled(obj.appearance.showSettingsSheet || obj.appearance.showApplicationSettings)
    }
}

#Preview {
  importButtons(
    obj: Object(),
    saveCount: .constant(10),
    viewModel: ContentViewModel(),
    isShowingGradientView: .constant(false),
    viewModelData: DataViewModel(),
    newCreatorsViewModel: NewImagesViewModel()
  )
}

