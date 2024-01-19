//
//  ShareImageButton.swift
//  M
//
//  Created by Sean Kelly on 04/11/2023.
//

import SwiftUI
import StoreKit


struct ShareImageButton: View {
    @Binding var showSymbolEffect: Bool
    @Binding var importedBackground: UIImage?
    @Binding var importedImage1: UIImage?
    @Binding var importedImage2: UIImage?
    @Binding var importedLogo: UIImage?
    var item: Item
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init()
    @State private var saveImage_showSheet: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @StateObject var obj: Object
    @AppStorage("saveToPhotos") private var saveToPhotos: Bool = true
    @Binding var saveCount: Int
    @AppStorage("requestReview") private var requestReviewCount: Int = 0
    @Environment(\.requestReview) var requestReview
    
    
    var body: some View {
        
        Image(systemName: "square.and.arrow.up.circle.fill")
            .font(.system(size: 35, weight: .medium))
            .symbolEffect(.pulse, value: showSymbolEffect)
            .foregroundColor(.primary)
            .rotationEffect(saveToPhotos ? .degrees(180) : .degrees(0))
            .onTapGesture {
                
                /*
                 UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 4, swipeToClose: true) { isDynamicIslandEnabled in
                     HStack {
                         Image("Pic")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 40, height: 40)
                             .clipShape(.circle)
                         
                         VStack(alignment: .leading, spacing: 6, content: {
                             Text("iJustine")
                                 .font(.caption.bold())
                                 .foregroundStyle(.white)
                             
                             Text("Hello, This is iJustine!")
                                 .textScale(.secondary)
                                 .foregroundStyle(.gray)
                         })
                         .padding(.top, 20)
                         
                         Spacer(minLength: 0)
                         
                         Button(action: {}, label: {
                             Image(systemName: "speaker.slash.fill")
                                 .font(.title2)
                         })
                         .buttonStyle(.bordered)
                         .buttonBorderShape(.circle)
                         .tint(.white)
                     }
                     .padding(15)
                     .background {
                         RoundedRectangle(cornerRadius: 15)
                             .fill(.black)
                     }
                 }
                 */
                
                feedback()
                showSymbolEffect.toggle()
                
                if obj.appearance.showGrid {
                    obj.appearance.showGrid.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        obj.appearance.showGrid.toggle()
                    }
                }
                
                withAnimation(.bouncy){
                    obj.appearance.showPill = true
                }
                
                let image = createSnapshot()
                
                if saveToPhotos {
                    handleSaveToPhotos(image: image)
                } else {
                    handleShare(image: image)
                }
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                feedback()
                saveToPhotos.toggle()
                saveImage_showSheet.present()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    saveImage_showSheet.dismiss()
                }
            }
            .padding()
            .background(Color.white.opacity(0.000001))
            .alert(alertConfig: $saveImage_showSheet) {
                createAlert(title: saveToPhotos ? "Saving to Photos Album" : "Changed to Share Sheet", imageName: "info.circle")
            }
            .alert(alertConfig: $alert) {
                createAlert(title: saveToPhotos ? "Saved Successfully!" : "Shared Successfully!", imageName: "checkmark.circle")
            }
            .alert(alertConfig: $alertError) {
                createAlert(title: saveToPhotos ? "Error Saving!" : "Error Sharing!", imageName: "exclamationmark.triangle")
            }
    }
    
    private func createSnapshot() -> UIImage {
        CustomImageView(item: item, importedBackground: $importedBackground, importedImage1: $importedImage1, importedImage2: $importedImage2, importedLogo: $importedLogo, obj: obj)
            .ignoresSafeArea(.all)
            .snapshot()
    }
    
    private func handleSaveToPhotos(image: UIImage) {
        let imageSaver = ImageSaver(alert: $alert, alertError: $alertError)
        imageSaver.writeToPhotoAlbum(image: image)
        saveCount += 1
        requestReviewPrompt()
    }
    
    private func handleShare(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                provideSuccessFeedback()
                alert.present()
                saveCount += 1
            } else if let error = error {
                print("Error sharing image: \(error.localizedDescription)")
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
    }
    
    private func createAlert(title: String, imageName: String) -> some View {
        alertPreferences(title: "\(title)")
    }
    
    private func alertPreferences(title: String) -> some View {
        Text(title)
            .foregroundStyle(item.alertTextColor)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(item.color.gradient)
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
    
    private func requestReviewPrompt() {
        requestReviewCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            if self.requestReviewCount == 10 || self.requestReviewCount == 50 || self.requestReviewCount == 100 {
                self.requestReview()
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

