//
//  DonationView.swift
//  M
//
//  Created by Sean Kelly on 30/11/2023.
//

import SwiftUI

struct DonationView: View {
    
    @StateObject var obj: Object
    @State private var showDonation: AlertConfig = .init(disableOutsideTap: false)
    
    
    var body: some View {
        
            VStack {
                
                Spacer()
                
                HStack {
                    Image(systemName: "giftcard")
                        .font(.title3)
                    
                    Text("Show Your Support")
                        .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.bottom, 5)
                
                HStack {
                    
                    Text("Your support means the world to us. Every contribution, no matter the amount, goes a long way in helping us continue creating and improving M App for you. Thank you for being a part of our journey!")
                        .font(.system(size: obj.appearance.settingsSliderFontSize))
                        .foregroundStyle(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        showDonation.present()
                    } label: {
                        Text("Support")
                            .font(.system(size: obj.appearance.settingsSliderFontSize).weight(.bold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 100))
                        
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.primary,  lineWidth: 1)
                    .padding()
            }
            
        
        .alert(alertConfig: $showDonation) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .colorInvert()
                
                VStack {
                    HStack {
                        Image(systemName: "giftcard")
                            .font(.title3)
                        
                        Text("Make A Donation")
                            .font(.system(size: obj.appearance.settingsSliderFontSize))
                        
                        Spacer()
                        
                        Button {
                            showDonation.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title3)
                        }
                        
                    }
                    .padding(.bottom, 20)
                    
                    HStack (spacing: 50) {
                      
                        IAPButton(iapText: "Bronze", subText: "", iapID: IAP.purchaseID_bronze, color: .brown, systemImage: "bag.circle", cornerradius: 24)
                        IAPButton(iapText: "Silver", subText: "", iapID: IAP.purchaseID_silver, color: .gray, systemImage: "bag.circle", cornerradius: 24)
                        IAPButton(iapText: "Gold", subText: "", iapID: IAP.purchaseID_gold, color: .yellow, systemImage: "bag.circle", cornerradius: 24)
                         
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .buttonStyle(.plain)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 180)
            
        }
    }
}

struct IAPButton: View {
    
    @State var iapText: String = "Silver"
    let subText: String
    @State var iapPrice: String = ""
    @State var iapID: String
    let color: Color
    let systemImage: String
    let cornerradius: CGFloat
    @State private var shine: Bool = false
    
    
    var body: some View {
        VStack {
            
            Text(iapText)
                .font(.system(size: 12).bold())
                .padding(.bottom, 5)
            
            if subText != "" {
                Text(subText)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 5)
            }
            
            Button {
                
                IAP.shared.purchase(iapID) { _ in
                }
                
                feedback()
                
            } label: {
            
                    VStack{
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: cornerradius)
                                .fill(color.opacity(1.0))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: systemImage)
                                        .foregroundColor(.white)
                                }
                               
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: cornerradius))
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                                .shine(shine, duration: 1, clipShape: .rect(cornerRadius: cornerradius))
                            
                        }
                        
                        Text(iapPrice) // IAP price goes here
                            .font(.system(size: 12).bold())
                            .padding(.top, 5)
                    }
                    .onAppear {
                        // Start a timer to toggle shine every 2 seconds
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                            shine.toggle()
                        }
                    }

            }
        }
        .onAppear {
            IAP.shared.requestProductData(iapID) { [self] product in
                if let product, let price = product.localizedPrice {
                    iapPrice = "\(price)"
                } else {
                    iapPrice = "Error"
                }
            } failed: { [self] _ in
                iapPrice = "Error"
            }
        }
    }
}
