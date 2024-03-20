//
//  UnlockPremiumView.swift
//  M
//
//  Created by Sean Kelly on 04/12/2023.
//

import SwiftUI

struct UnlockPremiumView: View {
    
    @StateObject var obj: Object
    @State var iapPrice: String = ""
    @State var iapID: String
    @State private var retryCount = 4
    @State private var unlockPremium: AlertConfig = .init(disableOutsideTap: false)
    
    let premiumUnlockedImages = ["premiumUnlocked", "premiumUnlocked2", "premiumUnlocked3"]
    @Binding var showPremiumContent: Bool
    @Binding var buyClicked: Bool
    
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                
                CrownView()
                
                Text("Unlock Premium Content")
                    .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                
                
                Spacer()
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            .opacity(showPremiumContent ? 0 : 1)
            
            
            HStack {
                
                Text("Unlock our premium selection of wallpapers and widgets not available anywhere else by making a one time purchase.")
                    .font(.system(size: obj.appearance.settingsSliderFontSize))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .opacity(showPremiumContent ? 0 : 1)
            
            if !showPremiumContent {
                HStack {
                    Spacer()
                    
                    Button {
                        feedback()
                        unlockPremium.present()
                        
                    } label: {
                        Text("Unlock Premium")
                    }
                    .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 100))
                    
                }
                .buttonStyle(.plain)
                .padding(.vertical)
                
            } else {
                HStack {
                    
                    Spacer()
                    Button {
                        unlockPremium.present()
                        
                        feedback()
                    } label: {
                        Text("Premium Unlocked!")
                            .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                            .foregroundStyle(.yellow)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 100))
                    }
                }
                .padding(.vertical)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .background{
            if showPremiumContent {
                
                ZStack {
                    Image(premiumUnlockedImages.randomElement() ?? "premiumUnlocked")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    HeartAnimationView()
                }
                .mask {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: UIScreen.main.bounds.width * 0.925)
                }
                .padding()
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.primary,  lineWidth: 1)
                    .padding()
            }
        }
        .onAppear {
            fetchIAPPrice()
            let _ = IAP.shared
        }
        .alert(alertConfig: $unlockPremium) {
            UnlockPremiumSheet(obj: obj, buyClicked: $buyClicked, unlockPremium: $unlockPremium)
        }
    }
    
    private func fetchIAPPrice() {
        IAP.shared.requestProductData(iapID) { [self] product in
            if let product, let price = product.localizedPrice {
                iapPrice = "Unlock Premium \(price)"
            } else {
                retryFetchPrice()
            }
        } failed: { [self] _ in
            retryFetchPrice()
        }
    }
    
    private func retryFetchPrice() {
        if retryCount > 0 {
            iapPrice = "Fetching Price"
            // Retry after a delay (e.g., 2 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                retryCount -= 1
                fetchIAPPrice()
            }
        } else {
            iapPrice = "Error Fetching Price"
        }
    }
}

struct UnlockPremiumSheet: View {
    
    @StateObject var obj: Object
    @Binding var buyClicked: Bool
    @Binding var unlockPremium: AlertConfig
    @State private var iAPcounter: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .colorInvert()
            
            VStack {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.title3)
                    
                    Text("Unlock Premium")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                    
                    Spacer()
                    
                    Button {
                        unlockPremium.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title3)
                    }
                    
                }
                .padding(.bottom, 20)
                
                HStack (spacing: 50) {
                    
                    IAPButton(iapText: "Unlock Premium", subText: "Unlock all premium wallpapers and features", iapID: IAP.purchaseID_UnlockPremium, color: .yellow, systemImage: "crown.fill", cornerradius: 4)
                    
                }
                
                Spacer()
                    .frame(height: 50)
                
                Button {
                    buyClicked = true
                    
                    IAP.shared.restorePurchases { _ in
                        buyClicked = false
                    
                        
                    } failed: { _ in
                        buyClicked = false
                    }
                    
                    feedback()
                    
                } label: {
                    Text("Restore Purchase")
                        .font(.system(size: 12).bold())
                }
                .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.ultraThinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 100))
                .disabled(buyClicked)
                
            }
            .padding()
        }
        //MARK: Shows Confetti when IAP is successful or restored - listens to IAP class
        .confettiCannon(counter: $iAPcounter)
        .confettiCannon(counter: $iAPcounter)
               .onReceive(NotificationCenter.default.publisher(for: .IAPManagerDidPurchaseProduct)) { _ in
                   iAPcounter += 1
               }
        .buttonStyle(.plain)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 180)
    }
}


