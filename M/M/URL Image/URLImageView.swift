//
//  URLImageView.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI
import SwiftUIX


struct URLImages: View {
    @StateObject var viewModelData: DataViewModel
    @StateObject var viewModelContent: ContentViewModel
    @State private var selectedImage: ImageModel?
    @State private var isSheetPresented = false
    @State private var saveState: SaveState = .idle
    @StateObject var obj: Object
    @Binding var isShowingGradientView: Bool
    
    enum SaveState {
        case idle
        case saving
        case saved
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
    
    @Binding var showPremiumContent: Bool
    @State private var premiumRequiredAlert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @Binding var isZooming: Bool
    @Binding var importedBackground: UIImage?
    
    var body: some View {
        ZStack {
            VStack {
                
                ButtonView(obj: obj, viewModelData: viewModelData, showPremiumContent: $showPremiumContent, isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground)
                
                if !viewModelData.images.isEmpty {
                    ScrollViewReader(content: { proxy in
                        ScrollView(.vertical, showsIndicators: true) {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: obj.appearance.showTwoWallpapers ? 2 : 3), spacing: 30) {
                                ForEach(viewModelData.images.indices.reversed(), id: \.self) { index in
                                    WallpaperImageView(
                                        imageURL: URL(string: viewModelData.images[index].image)!,
                                        isPremium: viewModelData.images[index].image.contains("p_"),
                                        isNew: viewModelData.images[index].isNew,
                                        onTap: {
                                            if viewModelData.images[index].image.contains("p_") && !showPremiumContent {
                                                premiumRequiredAlert.present()
                                            } else {
                                                selectedImage = viewModelData.images[index]
                                                isSheetPresented = true
                                                saveState = .idle
                                            }
                                        },
                                        obj: obj,
                                        premiumRequiredAlert: $premiumRequiredAlert
                                    )
                                }
                            }
                            .padding(10)
                            .scrollTargetLayout()
                            
                            Spacer()
                                .frame(height: 100)
                        }
                        .refreshable {
                            // Handle pull-to-refresh here
                            viewModelData.forceRefresh.toggle()
                        }
                    })
                    
                } else {
                    // Show loading images view when no images have been loaded yet
                    LoadingImagesView(obj: obj)
                }
                
                Spacer()
            }
        }
        .preferredColorScheme(colorScheme)
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(item: $selectedImage) { image in
            SheetContentView(viewModel: viewModelData, image: image, viewModelContent: viewModelContent, saveState: $saveState, obj: obj, isZooming: $isZooming, showPremiumContent: $showPremiumContent, isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground, selectedImage: $selectedImage)
                .onDisappear {
                    viewModelData.loadImages()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Check the downward direction and minimum distance
                            if value.translation.height > 50 {
                                selectedImage = nil
                            }
                        }
                )
        }
        .onDisappear {
            selectedImage = nil
        }
        .onChange(of: saveState) {
            if saveState == .saved {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    selectedImage = nil
                    saveState = .idle // Reset saveState
                }
            }
        }
        .onChange(of: selectedImage) {
            if selectedImage != nil {
                isSheetPresented = true
            }
        }
        .onAppear {
            viewModelData.loadImages()
        }
        .onReceive(viewModelData.$forceRefresh) { refresh in
            if refresh {
                viewModelData.loadImages()
            }
        }
    }
    
    private func getFileName(from urlString: String) -> String {
        if let url = URL(string: urlString) {
            return url.deletingPathExtension().lastPathComponent
        }
        return ""
    }
    
    private func alertPreferences(title: String, imageName: String) -> some View {
        VStack {
            
            Text("\(Image(systemName: imageName)) \(title)")
            
            Text("Open settings to unlock premium")
                .font(.system(size: 12, design: .rounded))
                .padding(.top, 5)
            
        }
        .foregroundStyle(.black)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.yellow)
        }
    }
    
}
