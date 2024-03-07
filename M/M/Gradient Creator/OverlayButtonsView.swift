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
    
    
    var body: some View {
        ZStack {
            if !isSavingImage {
                VStack {
                    
                    //MARK: Xmark
                    HStack {
                        
                        UltraThinButton(action: {
                            isShowingGradientView.toggle()
                            activeTab = .mockup
                            
                        }, systemName: "xmark.circle", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                        .offset(x: showGradientControl ? -offsetValue : 0)
                        .animation(.bouncy, value: showGradientControl)
                        
                        Spacer()
                        
                        Picker("Gradient Style", selection: $gradientStyle) {
                            ForEach(GradientView.GradientStyle.allCases) { style in
                                Text(style.rawValue.capitalized)
                                    .tag(style)
                            }
                        }
                        .shadow(radius: 3)
                        .offset(x: showGradientControl ? offsetValue : 0)
                        .animation(.bouncy, value: showGradientControl)
                        .disabled(importedBackground != nil)
                        .opacity(importedBackground != nil ? 0.5 : 1)
                        
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
                        .disabled(importedBackground != nil)
                        .opacity(importedBackground != nil ? 0.5 : 1)
                        
                        
                        //MARK: BG Image
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showGradientBgPickerSheet.toggle()
                            }, systemName: importedBackground == nil ? "custom.photo.circle.fill.badge.plus" : "custom.photo.circle.badge.plus.badge.xmark", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: false, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                        //MARK: Overlay Image = URL
                        
                        HStack {
                            Spacer()
                            
                            ZStack {
                                
                                UltraThinButton(action: {
                                    selectedURLOverlayImages.removeLast() // Remove the last added image
                                    
                                }, systemName: "arrow.uturn.backward.circle", gradientFill: false, fillColor: Color.red, showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                                .offset(x: !selectedURLOverlayImages.isEmpty ? -50 : 0)
                                .animation(.linear(duration: 0.2), value: !selectedURLOverlayImages.isEmpty)
                                .opacity(!selectedURLOverlayImages.isEmpty ? 1 : 0)
                                
                                UltraThinButton(action: {
                                    showOverlaysURLView.toggle()
                                    
                                }, systemName: "apps.iphone.badge.plus", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                                
                            }
                            .padding(.trailing)
                            .padding(.top, 10)
                            
                        }
                        
                        
                        //MARK: Overlay Image = Photos Album
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                showImageOverlayPickerSheet.toggle()
                            }, systemName: importedImageOverlay == nil ? "custom.photo.circle.badge.plus" : "custom.photo.circle.badge.plus.badge.xmark", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: false, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                        
                        //MARK: Open Settings
                        HStack {
                            
                            Spacer()
                            
                            UltraThinButton(action: {
                                withAnimation(.bouncy) {
                                    showGradientControl.toggle()
                                }
                            }, systemName: "slider.horizontal.3", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: buttonScaleEffect, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                            .padding(.trailing)
                            .padding(.top, 10)
                        }
                        
                    }
                    .offset(x: showGradientControl ? offsetValue : 0)
                    .animation(.bouncy, value: showGradientControl)
                    
                    Spacer()
                    
                    // MARK: Save Image & Re-Order Gradient
                    VStack {
                        //MARK: Save Image - Snapshot
                        HStack {
                            
                            UltraThinButton(action: {
                                isSavingImage = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    saveImageToPhotoLibrary()
                                    
                                    DispatchQueue.main.async {
                                        alert.present()
                                        
                                        performDelayedAction(after: 2.0) {
                                            alert.dismiss()
                                            
                                            performDelayedAction(after: 0.3) {
                                                isSavingImage = false
                                            }
                                        }
                                    }
                                }
                            }, systemName: "square.and.arrow.up.circle.fill", gradientFill: false, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                            .padding(.bottom, 10)
                            
                            Spacer()
                        }
                        
                        //MARK: Re-Order Gradient
                        HStack {
                            UltraThinButton(action: {
                                generateGradient()
                            }, systemName: "arrow.clockwise.circle", gradientFill: true, fillColor: Color.blue.opacity(0.5), showUltraThinMaterial: true, useSystemImage: true, scaleEffect: 1, showOverlaySymbol: false, overlaySymbol: "", overlaySymbolColor:.clear)
                            
                            Spacer()
                        }
                        .disabled(importedBackground != nil)
                        .opacity(importedBackground != nil ? 0.5 : 1)
                    }
                    .padding(.bottom, 50)
                    .padding(.leading)
                    .offset(x: showGradientControl ? -offsetValue : 0)
                    .animation(.bouncy, value: showGradientControl)
                }
                .padding(.top, 50)
                .padding(.horizontal)
                .font(.footnote)
                .tint(.white)
            }
            
        }
        .frame(width: screenWidth, height: screenHeight)
        .sensoryFeedback(.selection, trigger: isTapped)
    }
    
    func saveImageToPhotoLibrary() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale // Use the screen scale for full resolution
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds, format: format)
        let image = renderer.image { context in
            // Add .withRenderingMode(.alwaysOriginal) to capture the original image
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }.withRenderingMode(.alwaysOriginal) // Apply .withRenderingMode(.alwaysOriginal) to the captured image
        
        PHPhotoLibrary.shared().performChanges({
            let pngData = image.pngData() // Convert the image to PNG data
            if let pngData = pngData {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: pngData, options: nil)
            }
        }) { _, error in
            if let error = error {
                print("Failed to save image to photo library:", error)
            } else {
                print("Image saved to photo library successfully.")
            }
        }
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
