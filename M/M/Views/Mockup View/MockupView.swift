//
//  MockupView.swift
//  M
//
//  Created by Sean Kelly on 29/11/2023.
//

import SwiftUI
import TipKit

struct MockupView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var obj: Object
    @ObservedObject var viewModelData: DataViewModel
    @AppStorage("saveCount") private var saveCount: Int = 0
    @ObservedObject var newCreatorsViewModel: NewImagesViewModel
    @ObservedObject var imageURLStore: ImageURLStore
    @ObservedObject var manager = MotionManager()
    
    @Binding var showPremiumContent: Bool
    @Binding var buyClicked: Bool
    @Binding var isZooming: Bool
    @Binding var showCoverFlow: Bool
    @Binding var showOnboarding: Bool
    @Binding var isShowingGradientView: Bool
    @Binding var isScrollingSettings: Bool
    
    var screenOffset: Bool {
           return UIScreen.main.bounds.height > 852
       }
    
    var colorScheme: ColorScheme? {
        switch obj.appearance.selectedAppearance {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
   
    
    var body: some View {
        ZStack {
            CustomPagingSlider(showCoverFlow: $showCoverFlow, isZooming: $isZooming, data: $viewModel.items) { $item in
                
                //MARK: Mockup Image
                CustomImageView(item: item, importedBackground: $viewModel.importedBackground, importedImage1: $viewModel.importedImage1, importedImage2: $viewModel.importedImage2, importedLogo: $viewModel.importedLogo, obj: obj, imageURLStore: imageURLStore)
                    .customImageViewModifier(obj: obj, viewModel: viewModel, isZooming: $isZooming)
                 
                //MARK: Button to save to photos or files
                    ShareImageButton(showSymbolEffect: $obj.appearance.showSymbolEffect, importedBackground: $viewModel.importedBackground, importedImage1: $viewModel.importedImage1, importedImage2: $viewModel.importedImage2, importedLogo: $viewModel.importedLogo, item: item, obj: obj, saveCount: $saveCount, imageURLStore: imageURLStore)
                        .titleViewModifier(obj: obj, normalScale: 1.0)
                        .disabled(viewModel.importedImage1 == nil)
                        .offset(y: self.calculateYOffsetButton())
                        
            } titleContent: { $item in
                
                //MARK: Mockup Titles
                TitleContent(itemTitle: item.title, itemSubTitle: item.subTitle)
                .titleViewModifier(obj: obj, normalScale: 0.8)
                .offset(y: self.calculateYOffsetTitle())
              
            }
            .onAppear{
                print(UIScreen.main.bounds.height)
            }
            .offset(y: screenOffset ? -30 : 0)
            .fullScreenCover(isPresented: $viewModel.showImagePickerSheet1) {
                //MARK: Screenshot Image 1
                fullScreenImagePickerCover(for: $viewModel.importedImage1) { images in
                    viewModel.importedImage1 = images.first
                }
            }
            .fullScreenCover(isPresented: $viewModel.showImagePickerSheet2) {
                //MARK: Screenshot Image 2
                fullScreenImagePickerCover(for: $viewModel.importedImage2) { images in
                    viewModel.importedImage2 = images.first
                }
            }
            .fullScreenCover(isPresented: $viewModel.showBgPickerSheet) {
                //MARK: Imported Background Image
                fullScreenImagePickerCover(for: $viewModel.importedBackground) { images in
                    viewModel.importedBackground = images.first
                }
            }
            .fullScreenCover(isPresented: $viewModel.showLogoPickerSheet) {
                //MARK: Imported User Logo or Avatar Image
                fullScreenImagePickerCover(for: $viewModel.importedLogo) { images in
                    viewModel.importedLogo = images.first
                }
            }
            .sheet(isPresented: $obj.appearance.showSettingsSheet, content: {
                //MARK: Mockup View Settings
                SettingsView(viewModel: viewModel, obj: obj)
            })

            //MARK: Pill Buttons for importing user images etc
            importButtons(obj: obj, saveCount: $saveCount, viewModel: viewModel, isShowingGradientView: $isShowingGradientView, viewModelData: viewModelData, newCreatorsViewModel: newCreatorsViewModel)
        }
        .preferredColorScheme(colorScheme)
        .onTapGesture {
                if !obj.appearance.showPill {
                    obj.appearance.showPill = true
                }
        }
    }
    
    func calculateYOffsetTitle() -> CGFloat {
          let screenHeight = UIScreen.main.bounds.height
          
          switch screenHeight {
          case 0...499:
              return 100 // Example offset value for smaller screens
          case 500...800:
              return 60 
          case 801...900:
              return 25 // Example offset value for medium-sized screens
          default:
              return 0 // Example offset value for larger screens
          }
      }
    
    func calculateYOffsetButton() -> CGFloat {
          let screenHeight = UIScreen.main.bounds.height
          
          switch screenHeight {
          case 0...499:
              return -100 // Example offset value for smaller screens
          case 500...800:
              return -50 
          case 801...900:
              return -40 // Example offset value for medium-sized screens
          default:
              return 0 // Example offset value for larger screens
          }
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
    func customImageViewModifier(obj: Object, viewModel: ContentViewModel, isZooming: Binding<Bool>) -> some View {
        self
            .scaleEffect(0.6)
            .frame(width: obj.appearance.frameWidth * 0.6, height: obj.appearance.frameHeight * 0.6)
            .clipped()
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 0.5)
            }
            .addPinchZoom(isZooming: isZooming)
            .scaleEffect(obj.appearance.screenWidth, anchor: .center)
            .if(obj.appearance.enableImportTapGestures) { view in
                view.onTapGesture(count: 2) {
                    viewModel.showBgPickerSheet = true
                }
                .onTapGesture(count: 1) {
                    viewModel.showImagePickerSheet1 = true
                }
                .gesture( // MARK: Drag up gesture to show settings sheet
                    DragGesture(minimumDistance: 30, coordinateSpace: .global)
                        .onEnded { value in
                            if value.translation.height < 0 {
                                obj.appearance.showSettingsSheet.toggle()
                                    if !obj.appearance.showPill {
                                        obj.appearance.showPill = true
                                    }
                            }
                        })
            }
            .offset(y: obj.appearance.showSettingsSheet ? -110 : 0)
            .animation(.snappy, value: obj.appearance.showSettingsSheet)
            .padding(-60)
    }
}

extension View {
    func titleViewModifier(obj: Object, normalScale: CGFloat) -> some View {
        self
            .scaleEffect(obj.appearance.showSettingsSheet || obj.appearance.isZoomActive ? 0 : normalScale)
            .opacity(obj.appearance.showSettingsSheet || obj.appearance.isZoomActive ? 0 : 1)
            .animation(.snappy, value: obj.appearance.showSettingsSheet || obj.appearance.isZoomActive)
    }
}



struct TitleContent: View {
    
    let itemTitle: String
    let itemSubTitle: String
 
    
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Text(itemTitle)
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                    .blendMode(.difference)
                
                Text(itemTitle)
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .blendMode(.hue)
                
                Text(itemTitle)
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                
                Text(itemTitle)
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.black)
                    .blendMode(.overlay)
                
            }
            
        
            ZStack {
                Text(itemSubTitle)
                    .multilineTextAlignment(.center)
                
                    .foregroundColor(.white)
                    .blendMode(.difference)
                
                Text(itemSubTitle)
                    .multilineTextAlignment(.center)
                
                    .blendMode(.hue)
                
                Text(itemSubTitle)
                    .multilineTextAlignment(.center)
                
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                
                Text(itemSubTitle)
                    .multilineTextAlignment(.center)
                
                    .foregroundColor(.black)
                    .blendMode(.overlay)
            }
            .frame(height: 45)
        }
        .offset(y: 25)
        .scaleEffect(0.9)
    }
}

