//
//  WallpaperImageView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct WallpaperImageView: View {
    var imageURL: URL
    var isPremium: Bool
   // var isPaid: Bool // MARK: Re-enable this
    var isNew: Bool
    var onTap: () -> Void
    var obj: Object
    @Binding var premiumRequiredAlert: AlertConfig
    
    
    
    var body: some View {
        VStack {
            
            WebImage(url: imageURL)
                .resizable()
                .customFrameBasedOnCondition(obj: obj)
                .overlay {
                    if isPremium {
                        CrownOverlayView()
                    }
                    
                    if isNew {
                        NewWallAddedView()
                            .customFrameBasedOnCondition(obj: obj)
                    }
                    
                    // MARK: Enablke this for IAP
                    /*
                    if isPaid {
                        if imageURL.absoluteString.contains("p_") {
                            //MARK: Example View
                            IAPButtonWallView(iapID: IAP.purchaseID_M099, color: .brown, systemImage: "bag.fill", cornerradius: 24)
                        } else if imageURL.absoluteString.contains("M199_") {
                            // Open M199 view
                            // Example: M199View()
                        } else if imageURL.absoluteString.contains("M299_") {
                            // Open M299 view
                            // Example: M299View()
                        } else if imageURL.absoluteString.contains("M399_") {
                            // Open M399 view
                            // Example: M399View()
                        } else if imageURL.absoluteString.contains("M499_") {
                            // Open M499 view
                            // Example: M499View()
                        }
                    }
                     */
                }
                .onTapGesture {
                    onTap()
                }
                .alert(alertConfig: $premiumRequiredAlert) {
                    alertPreferences(title: "Premium Required!", imageName: "crown.fill")
                }
            
            let fileName = getFileName(from: imageURL.absoluteString)
            
            FileNameView(fileName: fileName)
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


struct IAPButtonWallView: View {
    
    @State var iapPrice: String = ""
    @State var iapID: String
    let color: Color
    let systemImage: String
    let cornerradius: CGFloat
    @State private var shine: Bool = false
    
    
    var body: some View {
        VStack {
            
            Button {
                
                IAP.shared.purchase(iapID) { _ in
                }
                
                feedback()
                
            } label: {
            /*
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
             */
                VStack {
                    
                    Spacer()
                    
                    Text(iapPrice) // IAP price goes here
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(4)
                        .background(Color.primary.colorInvert())
                        .cornerRadius(5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                             .stroke(Color.primary.opacity(0.4), lineWidth: 0.5)
                             .shadow(color: .black.opacity(0.4), radius: 1, y: 1)
                        )
                        .padding()
                      
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
