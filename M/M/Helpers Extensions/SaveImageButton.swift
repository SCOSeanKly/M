//
//  SaveImageButton.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct SaveImageButton: View {
    @Binding var showSymbolEffect: Bool
    @Binding var importedBackground: UIImage?
    @Binding var importedImage1: UIImage?
    @Binding var importedImage2: UIImage?
    @Binding var importedLogo: UIImage?
    var item: Item
    
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init()
    @StateObject var obj: Object
   
    
    var body: some View {
        Button {
            feedback()
            showSymbolEffect.toggle()
            
            let image = CustomImageView(item: item, importedBackground: $importedBackground, importedImage1: $importedImage1, importedImage2: $importedImage2, importedLogo: $importedLogo, obj: obj)
                .ignoresSafeArea(.all)
                .snapshot()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let imageSaver = ImageSaver(alert: $alert, alertError: $alertError)
                imageSaver.writeToPhotoAlbum(image: image)
            }
        } label: {
            
            ZStack {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.title)
                    .symbolEffect(.pulse, value: showSymbolEffect)
                    .tint(item.color)
            }
        }
        .padding()
        .alert(alertConfig: $alert) {
            
            Text("\(Image(systemName: "checkmark.circle")) Saved Successfully!")
                .foregroundStyle(.white)
                .foregroundStyle(.white)
                .padding(15)
                .background{
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
            VStack (spacing: -5){
                Text("\(Image(systemName: "exclamationmark.triangle")) Error Saving!")
                    .foregroundStyle(.white)
                    .padding(15)
                    .multilineTextAlignment(.center)
                
                Text("Please check app permissions")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(15)
                    .multilineTextAlignment(.center)
            }
            .background{
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


func feedback() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

func provideErrorFeedback() {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator.notificationOccurred(.error)
}

func provideSuccessFeedback() {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator.notificationOccurred(.success)
}

class ImageSaver: NSObject {
    var alert: Binding<AlertConfig>
    var alertError: Binding<AlertConfig>
    
    init(alert: Binding<AlertConfig>, alertError: Binding<AlertConfig>) {
        self.alert = alert
        self.alertError = alertError
        super.init()
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the error (e.g., show an error message) if the save operation failed.
            print("Error saving image: \(error.localizedDescription)")
            
            // Present the error alert when there's an error.
            provideErrorFeedback()
            alertError.wrappedValue.present()
            
            
        } else {
            // The image was saved successfully; you can present the success alert here.
            provideSuccessFeedback()
            alert.wrappedValue.present()
        }
    }
}



