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
    @Binding var showPremiumContent: Bool
    @Binding var buyClicked: Bool
    @Binding var showCoverFlow: Bool
    @Binding var showOnboarding: Bool
    
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
                
                UnlockPremiumView(obj: obj, iapID: IAP.purchaseID_UnlockPremium, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked)
                
                DonationView(obj: obj)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                
                //MARK: Application settings
                Group {
                    
                    //MARK: Onboarding diabled for now
                    /*
                    VStack {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .font(.title3)
                            
                            Text("Restart OnBoarding Help: ")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            
                            Spacer()
                            
                            AnimatedButton(action: {
                                
                                obj.appearance.showApplicationSettings.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showOnboarding.toggle()
                                }
            
                            }, sfSymbolName: "book.and.wrench", rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false, showOverlaySymbol: false, overlaySymbolName: "", overlaySymbolColor: .primary)
                            .padding(5)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        }
                        
                        HStack {
                            Text("Shows the onboarding help screens")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                        }
                    }
                    .padding(.vertical, 2.5)
                     */
                    
                    
                    VStack {
                        
                        HStack {
                            Image(systemName: "hand.tap")
                                .font(.title3)
                            
                            Text("Enable Import Tap Gestures: ")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            + Text("\(obj.appearance.enableImportTapGestures ? " Enabled" : " Disabled")")
                                .font(.system(size: obj.appearance.settingsSliderFontSize).smallCaps())
                            
                            Spacer()
                            
                            CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.enableImportTapGestures, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                                .offset(x: 15)
                        }
                        
                        HStack {
                            Text("Toggle on and off to allow single tap to import screenshot, double tap to import a background")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            
                            
                            Spacer()
                            
                        }
                    }
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
                            
                            
                            CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.showTwoWallpapers, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                                .offset(x: 15)
                            
                        }
                        
                        HStack {
                            Text("Switch between a 3 and 2 column style")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            
                            
                            Spacer()
                            
                        }
                    }
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
                    .padding(.vertical, 2.5)
                }
                .padding(.horizontal)
                
                
                //MARK: Select Icon view
                SelectIconView(obj: obj)
                
                Divider()
                    .padding([.horizontal, .vertical])
                
                
                
                Group {
                    
                    VStack {
                        HStack {
                            
                            Image(systemName: "square.stack.3d.down.right")
                                .font(.title3)
                            
                            Text("Mockup Coverflow View:")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            if !showPremiumContent {
                                Text("(PREMIUM)")
                                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                            }
                            
                            Spacer()
                            
                            CustomToggle(showTitleText: false, titleText: "", bindingValue: $showCoverFlow, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                                .offset(x: 15)
                            
                        }
                        
                        HStack {
                            Text("Switch between Coverflow and Slide view")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            
                            
                            Spacer()
                            
                        }
                    }
                    .padding(.vertical, 2.5)
                    
                    VStack {
                        HStack {
                            Image(systemName: "doc.plaintext")
                                .font(.title3)
                            
                            Text("Show AI prompt:")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            if !showPremiumContent {
                                Text("(PREMIUM)")
                                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                            }
                            
                            Spacer()
                            
                            CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.showAIPromptText, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                                .offset(x: 15)
                        }
                        
                        HStack {
                            Text("Shows the AI prompt text when available in the fullscreen wallpaper view")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            //  .frame(width: UIScreen.main.bounds.width * 0.8)
                            
                            Spacer()
                            
                        }
                    }
                    .padding(.vertical, 2.5)
                    
                    VStack {
                        HStack {
                            Image(systemName: "camera.filters")
                                .font(.title3)
                            
                            Text("Load full resolution preview:")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                            if !showPremiumContent {
                                Text("(PREMIUM)")
                                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                            }
                            
                            Spacer()
                            
                            CustomToggle(showTitleText: false, titleText: "", bindingValue: $obj.appearance.showFullResPreview, bindingValue2: nil, onSymbol: "circle", offSymbol: "xmark", rotate: false, onColor: .green, offColor: .gray, obj: obj)
                                .offset(x: 15)
                        }
                        
                        HStack {
                            Text("Loads the preview wallpaper image in full resolution")
                                .font(.system(size: obj.appearance.settingsSliderFontSize))
                                .foregroundStyle(.gray)
                            //   .frame(width: UIScreen.main.bounds.width * 0.8)
                            
                            Spacer()
                            
                        }
                    }
                    .padding(.vertical, 2.5)
                }
                .padding(.horizontal)
                .disabled(!showPremiumContent)
                .opacity(showPremiumContent ? 1 : 0.5)
                
                Divider()
                    .padding([.horizontal, .top])
                
                //MARK: Info view
                InfoView(obj: obj)
                
            }
        }
        .onAppear {
            let _ = IAP.shared
        }
        .sensoryFeedback(.selection, trigger: isTapped)
        .customPresentationWithBlur(detent: .large, blurRadius: 0, backgroundColorOpacity: 1.0)
        .preferredColorScheme(colorScheme)
        .ignoresSafeArea()
    }
}

func changeAppIcon(to iconName: String) {
    UIApplication.shared.setAlternateIconName(iconName) { error in
        if let error = error {
            print("Error setting alternate icon \(error.localizedDescription)")
        }
    }
}

struct SelectIconView: View {
    @StateObject var obj: Object
    @State private var isTapped: Bool = false
    @AppStorage ("AppIconSelection") var selectedIcon: String = "IconBlueM"
    let buttonSize: CGFloat = 36
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: "apps.iphone")
                    .font(.title3)
                
                Text("Application Icon")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                
                Spacer()
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["IconBlueM", "IconBlueM_White", "IconWhiteM", "IconPinkM", "IconMultiM", "IconAIM", "IconCamera"], id: \.self) { iconName in
                            Button {
                                changeAppIcon(to: iconName)
                                selectedIcon = iconName
                                
                            } label: {
                                
                                ZStack {
                                    Image("\(iconName)_preview")
                                        .resizable()
                                        .cornerRadius(10)
                                        .padding(1)
                                        .scaleEffect(selectedIcon == iconName ? 0.9 : 0.8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 11)
                                                .stroke(selectedIcon == iconName ? Color(.link).opacity(1.0) : Color.clear, lineWidth: 1.0)
                                                .scaleEffect(selectedIcon == iconName ? 0.9 : 0.8)
                                        )
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.45)
                .offset(y: 10)
                .sensoryFeedback(.selection, trigger: isTapped)
            }
            
            HStack {
                Text("Select an application icon")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundStyle(.gray)
                    .offset(y: -5)
                
                Spacer()
                
            }
        }
        .padding(.horizontal)
    }
}

struct InfoView: View {
    @StateObject var obj: Object
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            HStack {
                
                Image(systemName: "person.circle")
                    .font(.title3)
                
                Text("Contributors")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .padding(.bottom, 5)
                
                Spacer()
            }
            .padding(.top)
            HStack {
                Text("Thank you to all the contributors who have included their wallapers. Visit them on social media by tapping below.")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            CreatorProfiles(obj: obj)
            
            Divider()
                .padding(.vertical)
            
            HStack {
                
                Image(systemName: "info.circle")
                    .font(.title3)
                
                Text("Information")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .padding(.bottom, 5)
                    .padding(.top, 5)
                Spacer()
            }
            HStack {
                Text("All the wallpapers shown in the wallpaper section are property of the respective owners and can be used for personal use only. Any distrbution or sharing is not allowed without permission of the owner")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            HStack {
                Text("Widgy App is required to use the widgets shown in M. Download Widgy from the Appstore **HERE**")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 2.5)
                    .onTapGesture {
                        openURL(URL(string: "https://apps.apple.com/gb/app/widgy-widgets-home-lock-watch/id1524540481")!)
                    }
                
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 2.5)
        
        Spacer()
        
        //MARK: Show Creative View
        ShowCreative()
            .padding(.bottom, 50)
            .padding(.top, 5)
    }
}

