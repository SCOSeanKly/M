//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var obj: Object
    
    
    var body: some View {
        
        ZStack {
            
            CustomPagingSlider(data: $viewModel.items) { $item in
                
                CustomImageView(item: item, importedBackground: $viewModel.importedBackground, importedImage1: $viewModel.importedImage1, importedLogo: $viewModel.importedLogo, obj: obj)
                    .customImageViewModifier(obj: obj, viewModel: viewModel)
                 
                ShareImageButton(showSymbolEffect: $obj.appearance.showSymbolEffect, importedBackground: $viewModel.importedBackground, importedImage1: $viewModel.importedImage1, importedLogo: $viewModel.importedLogo, item: item, obj: obj)
                    .titleViewModifier(obj: obj, normalScale: 1.0)
                
                
                
            } titleContent: { $item in
                
                VStack(spacing: 5) {
                    
                    Text(item.title)
                        .font(.largeTitle.bold())
                    
                    Text(item.subTitle)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .frame(height: 45)
                }
                .titleViewModifier(obj: obj, normalScale: 0.8)
            }
            .safeAreaPadding([.horizontal, .top], 35)
            .fullScreenCover(isPresented: $viewModel.showBgPickerSheet) {
                fullScreenImagePickerCover(for: $viewModel.importedBackground) { images in
                    viewModel.importedBackground = images.first
                }
            }
            .fullScreenCover(isPresented: $viewModel.showImagePickerSheet1) {
                fullScreenImagePickerCover(for: $viewModel.importedImage1) { images in
                    viewModel.importedImage1 = images.first
                }
            }
            .fullScreenCover(isPresented: $viewModel.showLogoPickerSheet) {
                fullScreenImagePickerCover(for: $viewModel.importedLogo) { images in
                    viewModel.importedLogo = images.first
                }
            }
            .sheet(isPresented: $obj.appearance.showSettingsSheet, content: {
                SettingsView(viewModel: viewModel, obj: obj)
                
            })
            
            // Buttons
            VStack{
                HStack {
                    Spacer()
                    AnimatedButton(action: {
                        obj.appearance.showSettingsSheet.toggle()
                    }, sfSymbolName: "gearshape", rotationAntiClockwise: false, color: .blue, allowRotation: true)
                    .padding(.trailing)
                }
                
                HStack {
                    Spacer()
                    AnimatedButton(action: {
                        viewModel.showLogoPickerSheet.toggle()
                    }, sfSymbolName: "photo.circle", rotationAntiClockwise: false, color: .blue, allowRotation: false)
                    .padding(.trailing)
                    .padding(.top)
                }
                Spacer()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .global)
                .onEnded { value in
                    if value.translation.height < 0 {
                        obj.appearance.showSettingsSheet.toggle()
                    }
                })
    }
    
    private func fullScreenImagePickerCover(for binding: Binding<UIImage?>, completion: @escaping ([UIImage]) -> Void) -> some View {
        PhotoPicker(filter: .images, limit: 1) { results in
            PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                if let error = errorOrNil {
                    print(error)
                }
                if let images = imagesOrNil {
                    completion(images)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    func customImageViewModifier(obj: Object, viewModel: ContentViewModel) -> some View {
        self
            .scaleEffect(0.5)
            .frame(width: obj.appearance.frameWidth * 0.5, height: obj.appearance.frameHeight * 0.5)
            .clipped()
            .cornerRadius(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(obj.appearance.showBackground ? 0 : 1), lineWidth: 0.5)
            }
            .modifier(ZoomModifier(minimum: 1.0, maximum: 1.0, obj: obj))
            .scaleEffect(obj.appearance.screenWidth, anchor: .center)
            .onTapGesture(count: 2) {
                viewModel.showBgPickerSheet = true
            }
            .onTapGesture(count: 1) {
                viewModel.showImagePickerSheet1 = true
            }
            .offset(y: obj.appearance.showSettingsSheet ? -110 : 0)
            .animation(.bouncy, value: obj.appearance.showSettingsSheet)
            .padding(-60)
          
    }
}

extension View {
    func titleViewModifier(obj: Object, normalScale: CGFloat) -> some View {
        self
            .scaleEffect(obj.appearance.showSettingsSheet || obj.appearance.isZoomActive ? 0 : normalScale)
            .opacity(obj.appearance.showSettingsSheet || obj.appearance.isZoomActive ? 0 : 1)
            .animation(.bouncy, value: obj.appearance.showSettingsSheet || obj.appearance.isZoomActive)
    }
}



