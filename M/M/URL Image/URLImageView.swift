//
//  URLImageView.swift
//  M
//
//  Created by Sean Kelly on 17/11/2023.
//

import SwiftUI
import SwiftUIX
import SwiftUIIntrospect
import IsScrolling
import UIKit

struct URLImages: View {
    @StateObject var viewModelData: DataViewModel
    @StateObject var viewModelContent: ContentViewModel
    @State private var selectedImage: ImageModel?
    @State private var isSheetPresented = false
    @State private var saveState: SaveState = .idle
    @StateObject var obj: Object
    @Binding var isShowingGradientView: Bool
    
    // Add a state variable to hold the search query
    @State private var searchTextTemp = ""
    @State private var searchText = ""
    @State private var isFiltering = false
    
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
    @Binding var activeTab: Tab
    @Binding var isScrolling: Bool
    @StateObject var newCreatorsViewModel: NewImagesViewModel
    @StateObject var keyboardObserver: KeyboardObserver
    
    @Binding var wallpaperScollViewPosition: Int?
    
    var body: some View {
        VStack {
            
            ButtonView(obj: obj, viewModelData: viewModelData, showPremiumContent: $showPremiumContent, isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground, activeTab: $activeTab, newCreatorsViewModel: newCreatorsViewModel)

            if !filteredImages.isEmpty {
                
                SearchBarView(searchText: $searchText, isFiltering: $isFiltering, keyboardObserver: keyboardObserver, viewModelData: viewModelData)
                
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: obj.appearance.showTwoWallpapers ? 2 : 3), spacing: 30) {
                        ForEach(filteredImages.indices.reversed(), id: \.self) { index in
                            WallpaperImageView(
                                imageURL: URL(string: filteredImages[index].image)!,
                                isPremium: filteredImages[index].image.contains("p_"),
                                isNew: filteredImages[index].isNew,
                                onTap: {
                                    if filteredImages[index].image.contains("p_") && !showPremiumContent {
                                        premiumRequiredAlert.present()
                                    } else {
                                        selectedImage = filteredImages[index]
                                        isSheetPresented = true
                                        saveState = .idle
                                    }
                                    
                                    hideKeyboard()
                                },
                                obj: obj,
                                premiumRequiredAlert: $premiumRequiredAlert
                            )
                            .scrollSensor()
                        }
                    }
                    .padding(10)
                    .scrollTargetLayout()
                    .scrollStatusMonitor($isScrolling, monitorMode: .common)
                  
                    Spacer()
                        .frame(height: 100)
                }
                .scrollPosition(id: $wallpaperScollViewPosition)
                .onAppear {
                    //MARK: Dismisses new wallpapers added notification
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                        newCreatorsViewModel.reloadData()
                    }
                }
                .refreshable {
                    // Handle pull-to-refresh here
                    viewModelData.forceRefresh.toggle()
                }
            } else {
                // Show loading images view when no images have been loaded yet
                if searchText == "" {
                    //MARK: Progress View
                    LoadingImagesView(obj: obj)
                } else {
                    //MARK: Shows a button to reset the images filter
                    NofilteredImagesButton(searchText: $searchText, isFiltering: $isFiltering)
                }
            }
            
            Spacer()
        }
        .preferredColorScheme(colorScheme)
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(item: $selectedImage) { image in
            SheetContentView(viewModel: viewModelData, image: image, viewModelContent: viewModelContent, saveState: $saveState, obj: obj, isZooming: $isZooming, showPremiumContent: $showPremiumContent, isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground, selectedImage: $selectedImage, activeTab: $activeTab)
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
    
    // Filter images based on the search query
    var filteredImages: [ImageModel] {
        if searchText.isEmpty {
            return viewModelData.images
        } else {
            var matchedImages = Set<String>() // Set to store matched image URLs
            // Filter images by checking if the filename contains the search text
            let filtered = viewModelData.images.filter { imageModel in
                let imageName = getFileName(from: imageModel.image)
                let imageNameWithoutExtension = (imageName as NSString).deletingPathExtension
                let containsSearchText = imageNameWithoutExtension.localizedCaseInsensitiveContains(searchText)
                
                // Check if the extracted numbers exactly match the search text
                let imageNumbers = imageNameWithoutExtension.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let searchTextNumbers = searchText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let numberMatch = imageNumbers == searchTextNumbers
                
                if numberMatch && !matchedImages.contains(imageModel.image) {
                    matchedImages.insert(imageModel.image) // Add matched image URL to the set
                    print("Match found: \(imageModel.image)")
                    return true
                }
                return false
            }

            // Print if no matches are found
            if filtered.isEmpty {
                print("No matches found for search: \(searchText)")
            }

            return filtered
        }
    }

    // Function to extract filename from URL
    private func getFileName(from urlString: String) -> String {
        if let url = URL(string: urlString) {
            return url.lastPathComponent
        }
        return ""
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


