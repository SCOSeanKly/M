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
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    @State private var retryCount = 4
    @State private var unlockPremium: AlertConfig = .init(disableOutsideTap: false)
    
    var body: some View {
       
            VStack {
                
                Spacer()
                
                HStack {
                    Image(systemName: "star.square")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                    
                    Text("Unlock Premium Content")
                        .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.bottom, 5)
                
                HStack {
                    
                    Text("Unlock our premium selection of wallpapers not available anywhere else by making a one time purchase.")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                        .foregroundStyle(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                if !showPremiumContent {
                    HStack {
                        Spacer()
                        
                        Button {
                            
                            feedback()
                            
                            /*
                            IAP.shared.purchase(iapID) { _ in
                            }
                             */
                            
                            unlockPremium.present()
                            
                        } label: {
                            /*
                            if iapPrice == "Fetching Price" {
                                HStack {
                                    ProgressView()
                                        .padding(.trailing, 5)
                                       
                                    Text("Fetching Price")
                                }
                             
                            } else {
                                Text(iapPrice)
                                  
                            }
                             */
                            
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
                    
                            Text("Premium Unlocked!")
                                .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                                .foregroundStyle(.yellow)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.ultraThinMaterial)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 100))
                        
                    }
                  
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .alert(alertConfig: $unlockPremium) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .colorInvert()
                    
                    VStack {
                        HStack {
                            Image(systemName: "star.square")
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
                          
                            IAPButton(iapText: "Unlock Premium", subText: "Unlock all premium wallpapers", iapID: IAP.purchaseID_UnlockPremium, color: .yellow, systemImage: "star.square", cornerradius: 4)
                           
                             
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .buttonStyle(.plain)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 180)
                
            }
            .onAppear {
                let _ = IAP.shared
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.primary,  lineWidth: 1)
                    .padding()
            }
            .onAppear {
                       fetchIAPPrice()
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
