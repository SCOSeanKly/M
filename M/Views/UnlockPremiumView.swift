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
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                        feedback()
                        
                        IAP.shared.purchase(iapID) { _ in
                        }
                         
                    } label: {
                        Text(iapPrice)
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
        
        .onAppear {
            IAP.shared.requestProductData(iapID) { [self] product in
                if let product, let price = product.localizedPrice {
                    iapPrice = "Unlock Premium \(price)"
                } else {
                    iapPrice = "Error Fetching Price"
                }
            } failed: { [self] _ in
                iapPrice = "Error Fetching Price"
            }
        }
    }
}
