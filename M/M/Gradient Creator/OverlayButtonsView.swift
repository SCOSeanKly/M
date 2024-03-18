//
//  OverlayButtonsView.swift
//  M
//
//  Created by Sean Kelly on 22/02/2024.
//

import SwiftUI
import Photos

struct OverlayButtonsView: View {
    @Binding var isSavingImage: Bool
    @Binding var showGradientControl: Bool
    @Binding var isTapped: Bool
    @Binding var isShowingGradientView: Bool
    @Binding var gradientStyle: GradientView.GradientStyle
    @Binding var blendModeGradient: BlendMode
    @Binding var showGradientBgPickerSheet: Bool
    @Binding var showImageOverlayPickerSheet: Bool
    @State private var gradientColors = [Color]()
    @AppStorage("SelectedColorCount") private var selectedColorCount = 4
    @Binding var refreshButtonTapped: Bool
    @Binding var alert: AlertConfig
    @Binding var alertError: AlertConfig

    @Binding var importedBackground: UIImage?
    @Binding var showOverlaysURLView: Bool
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    //  @Binding var selectedURLOverlayImage: ImageModelOverlayImage?
    @Binding var selectedURLOverlayImages: [ImageModelOverlayImage]
    @Binding var importedImageOverlay: UIImage?
    let offsetValue: CGFloat = UIScreen.main.bounds.width * 0.5
    let buttonScaleEffect: CGFloat = 0.8
    @Binding var activeTab: Tab
    @Binding var hideGradient: Bool
    @State private var savedImage: UIImage?

  
    
    var body: some View {
        ZStack {
            if !isSavingImage {
                VStack {
                    //MARK: Xmark
                    HStack {
                        UltraThinButton(action: {
                            isShowingGradientView.toggle()
                            activeTab = .mockup
                            
                        }, systemName: "xmark.circle", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                        .offset(x: showGradientControl ? -offsetValue : 0)
                        .animation(.snappy, value: showGradientControl)
                        
                        Spacer()
                        
                        Picker("Gradient Style", selection: $gradientStyle) {
                            ForEach(GradientView.GradientStyle.allCases) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                        .shadow(radius: 3)
                        .offset(x: showGradientControl ? offsetValue : 0)
                        .animation(.snappy, value: showGradientControl)
                        
                    }
                    
                    Group {
                        //MARK: Blend Modes
                        HStack {
                            Spacer()
                            
                            Picker("Blend Mode", selection: $blendModeGradient) {
                                Group {
                                    Text("None").tag(BlendMode.normal)
                                    Text("Difference").tag(BlendMode.difference)
                                    Text("Exclusion").tag(BlendMode.exclusion)
                                    Text("Hard Light").tag(BlendMode.hardLight)
                                    Text("Soft Light").tag(BlendMode.softLight)
                                    Text("Color Burn").tag(BlendMode.colorBurn)
                                }
                                Group {
                                    Text("Color Dodge").tag(BlendMode.colorDodge)
                                    Text("Darken").tag(BlendMode.darken)
                                    Text("Lighten").tag(BlendMode.lighten)
                                    Text("Multiply").tag(BlendMode.multiply)
                                    Text("Overlay").tag(BlendMode.overlay)
                                    Text("Screen").tag(BlendMode.screen)
                                    Text("Plus Lighter").tag(BlendMode.plusLighter)
                                    
                                }
                            }
                            .shadow(radius: 3)
                        }
                        .disabled(hideGradient)
                        
                        //MARK: BG Image
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showGradientBgPickerSheet.toggle()
                            }, systemName: importedBackground == nil ? "custom.photo.circle.fill.badge.plus" : "custom.photo.circle.badge.plus.badge.xmark", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: false, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        .disabled(hideGradient)
                        
                        //MARK: Overlay Image = URL
                        HStack {
                            Spacer()
                            
                            ZStack {
                                
                                UltraThinButton(action: {
                                    selectedURLOverlayImages.removeLast() // Remove the last added image
                                    
                                }, systemName: "arrow.uturn.backward.circle", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                                .offset(x: !selectedURLOverlayImages.isEmpty ? -50 : 0)
                                .animation(.linear(duration: 0.2), value: !selectedURLOverlayImages.isEmpty)
                                .opacity(!selectedURLOverlayImages.isEmpty ? 1 : 0)
                                
                                UltraThinButton(action: {
                                    showOverlaysURLView.toggle()
                                    
                                }, systemName: "apps.iphone.badge.plus", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                                
                            }
                            .padding(.trailing)
                            .padding(.top, 10)
                            
                        }
                        
                        //MARK: Overlay Image = Photos Album
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showImageOverlayPickerSheet.toggle()
                            }, systemName: importedImageOverlay == nil ? "custom.photo.circle.badge.plus" : "custom.photo.circle.badge.plus.badge.xmark", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: false, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                        //MARK: Open Settings
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                withAnimation(.snappy) {
                                    showGradientControl.toggle()
                                }
                            }, systemName: "slider.horizontal.3", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                    }
                    .offset(x: showGradientControl ? offsetValue : 0)
                    .animation(.snappy, value: showGradientControl)
                    
                    Spacer()
                    
                    // MARK: Save Image & Re-Order Gradient
                    VStack {
                        //MARK: Save Image - Snapshot
                        HStack {
                            
                            UltraThinButton(action: {
                                isSavingImage = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if !hideGradient {
                                        saveImageToPhotoLibrary()
                                    } else {
                                        saveURLOverlayImagesToPhotoLibrary()
                                    }
                                }
                            }, systemName: "square.and.arrow.up.circle.fill", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                            .padding(.bottom, 10)
                            
                            Spacer()
                        }
                        
                        //MARK: Re-Order Gradient
                        HStack {
                            UltraThinButton(action: {
                                generateGradient()
                            }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: nil, overlaySymbolColor: nil)
                            
                            Spacer()
                        }
                        .disabled(hideGradient)
                    }
                    .padding(.bottom, 50)
                    .padding(.leading)
                    .offset(x: showGradientControl ? -offsetValue : 0)
                    .animation(.snappy, value: showGradientControl)
                }
                .padding(.top, 50)
                .padding(.horizontal)
                .font(.footnote)
                .tint(.white)
            }
        }
        .alert(alertConfig: $alert) {
            alertPreferences(title: "Saved Successfully!",
                                        imageName: "checkmark.circle")
        }
        .alert(alertConfig: $alertError) {
            alertPreferences(title: "Error Saving!",
                                        imageName: "exclamationmark.triangle")
        }
        .background(Color.clear)
        .frame(width: screenWidth, height: screenHeight)
        .sensoryFeedback(.selection, trigger: isTapped)
    }
    
    func alertPreferences(title: String, imageName: String) -> some View {
           Text("\(Image(systemName: imageName)) \(title)")
            .foregroundStyle(.white)
               .padding(15)
               .background {
                   RoundedRectangle(cornerRadius: 15)
                       .fill(Color.black.gradient)
               }
               .onAppear(perform: {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                       alert.dismiss()
                   }
               })
               .onTapGesture {
                   alert.dismiss()
               }
       }
    
    func saveURLOverlayImagesToPhotoLibrary() {
        let imageExporter = ImageExporter()
        
        var loadedImages = [UIImage?](repeating: nil, count: selectedURLOverlayImages.count) // Initialize an array to hold loaded images
        
        let dispatchGroup = DispatchGroup()
        
        for (index, image) in selectedURLOverlayImages.enumerated() {
            guard let imageURL = URL(string: image.image) else {
                continue
            }
            
            dispatchGroup.enter()
            
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                defer {
                    dispatchGroup.leave()
                }
                guard let data = data, error == nil else { return }
                guard let loadedImage = UIImage(data: data) else { return }
                
                loadedImages[index] = loadedImage // Store loaded image at the correct index
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            // Ensure all images are loaded before proceeding
            
            let orderedImages = loadedImages.compactMap { $0 } // Remove nil entries
            
            // Call mergeImages function of ImageExporter class
            imageExporter.mergeImages(orderedImages, outputSize: UIScreen.main.bounds.size)
            
            // Access the merged image from ImageExporter
            guard let mergedImage = imageExporter.image else {
                return
            }
            
            // Convert the merged image to PNG format
            guard let pngData = mergedImage.pngData() else {
                return
            }
            
            // Unwrap the PNG data and save it to the photo library
            if let unwrappedImage = UIImage(data: pngData) {
                UIImageWriteToSavedPhotosAlbum(unwrappedImage, nil, nil, nil)
            }
        }
    }
    
    func saveImageToPhotoLibrary() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds, format: format)
        let image = renderer.image { context in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }.withRenderingMode(.alwaysOriginal)
        
        // Convert the captured image to PNG format
        guard let pngData = image.pngData() else {
            // Handle conversion failure
            return
        }
        
        // Create UIImage from PNG data
        guard let pngImage = UIImage(data: pngData) else {
            // Handle UIImage creation failure
            return
        }
        
        let imageSaver = ImageSaver(alert: $alert, alertError: $alertError)
        
        // Save the PNG image to the photo library
        imageSaver.writeToPhotoAlbum(image: pngImage)
    }





    func performDelayedAction(after interval: TimeInterval, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: action)
    }
    
    func generateGradient() {
        let selectedColors = gradientColors.prefix(selectedColorCount)
        gradientColors = selectedColors.shuffled() + gradientColors.dropFirst(selectedColorCount)
        refreshButtonTapped.toggle()
    }
}
