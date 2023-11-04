//
//  ShareImageButton.swift
//  M
//
//  Created by Sean Kelly on 04/11/2023.
//

import SwiftUI

struct ShareImageButton: View {
    @Binding var showSymbolEffect: Bool
    @Binding var importedBackground: UIImage?
    @Binding var importedImage1: UIImage?
    @Binding var importedLogo: UIImage?
    var item: Item
    
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init()
    @State private var saveImage_showSheet: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @StateObject var obj: Object
    @AppStorage("saveToPhotos") private var saveToPhotos: Bool = true
    
    
    var body: some View {
        /*
         Button {
         feedback()
         showSymbolEffect.toggle()
         
         let image = CustomImageView(item: item, importedBackground: $importedBackground, importedImage1: $importedImage1, importedLogo: $importedLogo, obj: obj)
         .ignoresSafeArea(.all)
         .snapshot()
         
         let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
         
         activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
         if completed {
         // The user successfully shared the image
         provideSuccessFeedback()
         alert.present()
         } else {
         // An error occurred or the user canceled
         if let error = error {
         print("Error sharing image: \(error.localizedDescription)")
         }
         provideErrorFeedback()
         alertError.present()
         }
         }
         
         if let keyWindowScene = UIApplication.shared.connectedScenes
         .compactMap({ $0 as? UIWindowScene })
         .first(where: { $0.activationState == .foregroundActive }) {
         if let keyWindow = keyWindowScene.windows.first(where: { $0.isKeyWindow }) {
         keyWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
         }
         }
         } label: {
         
         Image(systemName: "square.and.arrow.up.circle.fill")
         .font(.title)
         .symbolEffect(.pulse, value: showSymbolEffect)
         .tint(item.color)
         
         }
         */
        
        Image(systemName: "square.and.arrow.up.circle.fill")
            .font(.title)
            .symbolEffect(.pulse, value: showSymbolEffect)
            .foregroundColor(item.color)
            .onTapGesture {
                
                feedback()
                showSymbolEffect.toggle()
                
                if saveToPhotos {
                    
                    let image = CustomImageView(item: item, importedBackground: $importedBackground, importedImage1: $importedImage1, importedLogo: $importedLogo, obj: obj)
                        .ignoresSafeArea(.all)
                        .snapshot()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let imageSaver = ImageSaver(alert: $alert, alertError: $alertError)
                        imageSaver.writeToPhotoAlbum(image: image)
                    }
                } else {
                    
                    let image = CustomImageView(item: item, importedBackground: $importedBackground, importedImage1: $importedImage1, importedLogo: $importedLogo, obj: obj)
                        .ignoresSafeArea(.all)
                        .snapshot()
                    
                    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    
                    activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                        if completed {
                               // The user successfully shared the image
                               provideSuccessFeedback()
                               alert.present()
                           } else if let error = error {
                               // An error occurred
                               print("Error sharing image: \(error.localizedDescription)")
                               provideErrorFeedback()
                               alertError.present()
                           } else {
                               // The user cancelled
                           }
                    }
                    
                    if let keyWindowScene = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first(where: { $0.activationState == .foregroundActive }) {
                        if let keyWindow = keyWindowScene.windows.first(where: { $0.isKeyWindow }) {
                            keyWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
            .onLongPressGesture(minimumDuration: 0.5){
                feedback()
                saveToPhotos.toggle()
                saveImage_showSheet.present()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    saveImage_showSheet.dismiss()
                }
            }
            .padding()
            .alert(alertConfig: $saveImage_showSheet) {
                Text(saveToPhotos ? "\(Image(systemName: "info.circle")) Saving to Photos Album" : "\(Image(systemName: "info.circle")) Changed to Share Sheet")
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color)
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
            .alert(alertConfig: $alert) {
                Text("\(Image(systemName: "checkmark.circle")) Saved Successfully!")
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color)
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
            .alert(alertConfig: $alertError) {
                VStack(spacing: -5) {
                    Text("\(Image(systemName: "exclamationmark.triangle")) Error Saving!")
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                    
                    Text("Please check app permissions or user cancelled")
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                }
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(item.color)
                }
                .onAppear(perform: {
                    alert.dismiss()
                })
                .onTapGesture {
                    alert.dismiss()
                }
            }
    }
}
