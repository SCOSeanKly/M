//
//  SheetContentView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

struct SheetContentView: View {
    @StateObject var viewModel: DataViewModel
    let image: ImageModel
    @StateObject var viewModelContent: ContentViewModel
    @Binding var saveState: URLImages.SaveState
    @StateObject var obj: Object
    @State private var isTapped: Bool = false
    let saveTip = SaveWallpaperTip()
    @Binding var isZooming: Bool
    @Binding var showPremiumContent: Bool
    let error: String = "ERROR - FILE DOES NOT EXIST"
    @State private var isNoAIPromptVisible: Bool = false
    @State private var isNoAIPromptVisibleAnimation: Bool = false
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .top)
    @State private var alertError: AlertConfig = .init()
    
    // Progress bar related state
    @State private var downloadProgress: Double = 0.0

    var body: some View {
        LargeImageView(image: image, viewModelContent: viewModelContent, obj: obj, showPremiumContent: $showPremiumContent, isZooming: $isZooming, isNoAIPromptVisible: $isNoAIPromptVisible, isNoAIPromptVisibleAnimation: $isNoAIPromptVisibleAnimation)
            .overlay {
                VStack {
                    Spacer()
                    Button {
                        isTapped.toggle()
                        saveImage()
                    } label: {
                        switch saveState {
                        case .idle:
                            SaveStateIdle()
                        case .saving:
                            SaveStateSaving(progress: $downloadProgress)
                        case .saved:
                            SaveStateSaved()
                        }
                    }
                    .padding(8)
                    .background(Color.primary.colorInvert())
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .animation(.bouncy, value: saveState)
                    .sensoryFeedback(.selection, trigger: isTapped)
                    .opacity(isZooming ? 0 : 1)
                    .animation(.smooth, value: isZooming)
                }
                .frame(height: UIScreen.main.bounds.height * 0.8)
            }
        
    }

    private func saveImage() {
        saveState = .saving
        
        guard var urlComponents = URLComponents(string: image.image) else {
            saveState = .idle
            return
        }
        
        if var pathComponents = urlComponents.path.components(separatedBy: "/") as [String]? {
            if let imageName = pathComponents.last {
                let modifiedImageName: String
                if imageName.lowercased().hasSuffix(".jpg") {
                    modifiedImageName = imageName.replacingOccurrences(of: ".jpg", with: "_fullRes.PNG", options: .caseInsensitive)
                } else {
                    modifiedImageName = imageName
                }
                
                pathComponents[pathComponents.count - 1] = modifiedImageName
                urlComponents.path = pathComponents.joined(separator: "/")
                
                guard let modifiedURL = urlComponents.url else {
                    saveState = .idle
                    return
                }
                
                let delegate = ImageDownloadDelegate(saveState: $saveState, progressCallback: { progress in
                    // Update the progress in your UI
                    downloadProgress = progress
                })

                let delegateQueue = OperationQueue.main
                let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: delegateQueue)

                let dataTask = session.dataTask(with: modifiedURL)
                delegate.task = dataTask

                // Resume the data task
                dataTask.resume()

                URLSession.shared.dataTask(with: modifiedURL) { data, response, error in
                    if let data = data, let originalUIImage = UIImage(data: data) {
                        // Save the original image as PNG
                        if let pngData = originalUIImage.pngData() {
                            UIImage(data: pngData)?.writeToPhotosAlbum()
                        
                            // Introduce a delay before transitioning to "saved"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                saveState = .saved
                                if downloadProgress > 0.99 {
                                    provideSuccessFeedback()
                                }
                            }
                            viewModel.loadImages()
                            print("Saved to photos")
                        } else {
                            saveState = .idle
                        }
                    } else {
                        saveState = .idle
                    }
                }.resume()
            }
        }
    }

    class ImageDownloadDelegate: NSObject, URLSessionDataDelegate {
        var task: URLSessionDataTask?
        var progressCallback: ((Double) -> Void)?
        var saveState: Binding<URLImages.SaveState>

        init(saveState: Binding<URLImages.SaveState>, progressCallback: @escaping (Double) -> Void) {
            self.saveState = saveState
            self.progressCallback = progressCallback
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            let progress = Double(dataTask.countOfBytesReceived) / Double(dataTask.countOfBytesExpectedToReceive)

            DispatchQueue.main.async {
                self.progressCallback?(progress)
            }
        }

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                print("Download failed with error: \(error.localizedDescription)")
                
                // Handle the error and update UI accordingly
                DispatchQueue.main.async {
                    self.saveState.wrappedValue = .idle
                }
            } else {
                // Introduce a delay before transitioning to "saved"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // Update UI to indicate successful download
                    print("Download Progress: 1.0 (completed)")
                    self.saveState.wrappedValue = .saved
                }
            }
        }
    }

}


