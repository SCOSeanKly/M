//
//  ApplicationSettings.swift
//  M
//
//  Created by Sean Kelly on 30/11/2023.
//

import SwiftUI

struct ApplicationSettings: View {
    
    @StateObject var obj: Object
    @State private var isTapped: Bool = false
    @State private var toggleStates: [ToggleState] = [.first, .second, .third]
    
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
    
    var appearanceName: String {
           switch obj.appearance.selectedAppearance {
           case .light:
               return " Light"
           case .dark:
               return " Dark"
           case .system:
               return " System"
           }
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
    
    var gridStyle: String {
        switch obj.appearance.showTwoWallpapers {
        case true:
            return "TWO"
        case false:
            return "THREE"
        }
    }
    
  
    var body: some View {
      
        VStack {
            
            //MARK: Title
            HStack {
                Text("Application Settings")
                    .font(.headline)
                 
                Spacer()
            }
            .padding([.horizontal, .top])
            .padding(.top)
          
            //MARK: Donation View
            
            ScrollView(.vertical, showsIndicators: false) {
                UnlockPremiumView(obj: obj, iapID: IAP.purchaseID_UnlockPremium)
                
                DonationView(obj: obj)
                    .offset(y: -10)
                
                Divider()
                    .padding([.horizontal, .bottom])
                
                
                //MARK: Application settings
                VStack {
                    HStack {
                        Image(systemName: "hand.tap")
                            .font(.title3)
                        
                        Text("Enable Import Tap Gestures: ")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        + Text("\(obj.appearance.enableImportTapGestures ? " Enabled" : " Disabled")")
                            .font(.system(size: obj.appearance.settingsSliderFontSize).smallCaps())
                        
                        Spacer()
                        
                        CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.enableImportTapGestures, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                            .offset(x: 15)
                    }
                    
                    HStack {
                        Text("Toggle on and off to allow single tap to import screenshot, double tap to import a background")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundStyle(.gray)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                        
                        Spacer()
                        
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 2.5)
                
                
                
                VStack {
                    HStack {
                        
                        Image(systemName: "lightbulb.min")
                            .font(.title3)
                        
                        Text("Appearance Mode: ")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        + Text ("\(appearanceName)")
                            .font(.system(size: obj.appearance.settingsSliderFontSize).smallCaps())
                        
                        Spacer()
                        
                        AnimatedButton(action: {
                            
                            isTapped.toggle()
                            
                            switch obj.appearance.selectedAppearance {
                            case .system:
                                obj.appearance.selectedAppearance = .light
                            case .light:
                                obj.appearance.selectedAppearance = .dark
                            case .dark:
                                obj.appearance.selectedAppearance = .system
                            }
                            
                        }, sfSymbolName: symbolName, rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "plus.circle", overlaySymbolColor: .primary)
                        .padding(5)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                    }
                    
                    HStack {
                        Text("Switch between system, light and dark mode")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundStyle(.gray)
                        
                        
                        Spacer()
                        
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 2.5)
                
                VStack {
                    HStack {
                        
                        Image(systemName: "rectangle.grid.3x2")
                            .font(.title3)
                        
                        Text("3 or 2 Wallpaper Columns: ")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        + Text ("\(gridStyle)")
                            .font(.system(size: obj.appearance.settingsSliderFontSize).smallCaps())
                        
                        Spacer()
                        
                        
                        CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.showTwoWallpapers, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                            .offset(x: 15)
                        
                    }
                    
                    HStack {
                        Text("Switch between a 3 and 2 column style")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundStyle(.gray)
                        
                        
                        Spacer()
                        
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 2.5)
                
                Divider()
                    .padding([.horizontal, .top])
                
                //MARK: Copyright view
                VStack {
                    HStack {
                        Text("Copyright")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .padding(.bottom, 5)
                            .padding(.top, 2.5)
                        Spacer()
                    }
                    HStack {
                        Text("All the wallpapers shown in the wallpaper section are property of ShowCreative and can be used for personal use only. Any distrbution or sharing is not allowed without permission of the owner")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                            .foregroundStyle(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 2.5)
                
                Spacer()
                
                //MARK: Show Creative View
                ShowCreative()
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            let _ = IAP.shared
        }
        .ignoresSafeArea(edges: .bottom)
        .sensoryFeedback(.selection, trigger: isTapped)
        .customPresentationWithBlur(detent: .large, blurRadius: 0, backgroundColorOpacity: 1.0)
        .frame(height: UIScreen.main.bounds.height * 0.875)
        .preferredColorScheme(colorScheme)
    }
    
    
}
