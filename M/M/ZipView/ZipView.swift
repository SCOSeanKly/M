//
//  ZipView.swift
//  M
//
//  Created by Sean Kelly on 28/03/2024.
//

import SwiftUI
import IsScrolling
import SDWebImageSwiftUI


class DataViewModelZip: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var zipImages: [ZipModel] = []
    @Published var downloadProgress: Float = 0.0 // New property to track download progress

    func loadImages() {
        let urlString = "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/ZIP/zipFiles.json"

        guard let url = URL(string: urlString) else {
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10

        let session = URLSession(configuration: config)

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            do {
                let imageData = try JSONDecoder().decode([ZipData].self, from: data)
                DispatchQueue.main.async {
                    self.zipImages = imageData.map { imageData in
                        let fileName = URL(string: imageData.fileURL)?.lastPathComponent ?? "Unknown"
                        self.fetchFileSize(from: URL(string: imageData.fileURL)!) { fileSize in
                            // Here, fileSize may be nil if fetching fails
                            let fileSize = fileSize ?? 0
                            if let index = self.zipImages.firstIndex(where: { $0.fileURL == imageData.fileURL }) {
                                self.zipImages[index].fileSize = fileSize
                            }
                        }
                        return ZipModel(
                            image: imageData.image,
                            title: imageData.title,
                            subtitle: imageData.subtitle,
                            fileURL: imageData.fileURL,
                            fileName: fileName,
                            fileSize: 0 // Default to 0 until file size is fetched
                        )
                    }
                }

            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    
    func fetchFileSize(from url: URL, completion: @escaping (Int?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String,
                  let fileSize = Int(contentLength) else {
                completion(nil)
                return
            }

            completion(fileSize)
        }

        task.resume()
    }

    
    func downloadZipFile(from url: URL) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

            // If the file already exists, remove it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }

            // Move the downloaded file to the destination
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File downloaded successfully: \(destinationUrl.absoluteString)")
            
            // Update file size in the corresponding ImageModelOverlayImage
            DispatchQueue.main.async {
                if let index = self.zipImages.firstIndex(where: { $0.fileURL == url.absoluteString }) {
                    let fileSize = try? FileManager.default.attributesOfItem(atPath: destinationUrl.path)[.size] as? Int
                    self.zipImages[index].fileSize = fileSize
                }
            }
            
            // Present share sheet
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first {
                    window.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }
            }
        } catch {
            print("File download failed:", error)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // Calculate download progress
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // Update progress property
        DispatchQueue.main.async {
            self.downloadProgress = progress
        }
    }
}

struct DownloadZipView: View {
    @StateObject var viewModelZipHeader = DataViewModelZip()
    @StateObject var obj: Object
    @Binding var isScrolling: Bool
    @State private var showAlert = false
    @State private var selectedZipModel: ZipModel?

    
    var body: some View {
        ZStack {
             HeaderButtons(obj: obj)

            if !viewModelZipHeader.zipImages.isEmpty {
                ScrollView(showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 30) {
                        ForEach(viewModelZipHeader.zipImages) { image in
                            Button {
                                selectedZipModel = image
                                showAlert = true // Set showAlert to true to show the alert
                            } label: {
                                ZipView(image: image)
                                    .cornerRadius(5)
                                    .padding(.horizontal, 5)
                            }
                            .scrollSensor()
                        }
                    }
                    .padding(.top, 10)
                    .scrollStatusMonitor($isScrolling, monitorMode: .common)
                }
                .padding(.top, 85)
            } else {
                HStack {
                    ProgressView()
                        .padding(.trailing, 5)
                    
                    Text("Loading...")
                        .font(.system(size: 12))
                }
            }
        }
        .onAppear {
            viewModelZipHeader.loadImages()
            print("Appeared")
        }
        .overlay(
            Group {
                if viewModelZipHeader.downloadProgress > 0.0 && viewModelZipHeader.downloadProgress < 1.0 {
                    // Progress view overlay
                }
            }
        )
        .alert(item: $selectedZipModel) { zipModel in
            Alert(
                title: Text("Confirmation"),
                message: getMessage(for: zipModel),
                primaryButton: .default(Text("Proceed")) {
                    if let url = URL(string: zipModel.fileURL) {
                        viewModelZipHeader.downloadZipFile(from: url)
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .overlay(
            // Display download progress as an overlay
            Group {
                if viewModelZipHeader.downloadProgress > 0.0 && viewModelZipHeader.downloadProgress < 1.0 {
                    
                    VStack {
                        
                      //MARK: ADD FILE NAME HERE
                        
                            ProgressView(value: viewModelZipHeader.downloadProgress,
                                         label: { Text("Downloading...") },
                                         currentValueLabel: {  Text("\(Int(viewModelZipHeader.downloadProgress * 100))%") })
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .padding()
                    .background(Color.primary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 200)
                }
            }
        )
    }
    

    // Helper function to construct the message for the alert
    private func getMessage(for zipModel: ZipModel) -> Text {
        let fileName = zipModel.fileName ?? "Unknown"
        let fileSize = formattedFileSize(zipModel.fileSize)
        return Text("Do you want to download '\(fileName)' (\(fileSize))?")
    }
    

    // Helper function to format file size
    private func formattedFileSize(_ fileSize: Int?) -> String {
        guard let fileSize = fileSize else {
            return "Unknown"
        }

        if fileSize < 1000 {
            return "\(fileSize) KB"
        } else {
            let fileSizeInMB = Double(fileSize) / (1024.0 * 1024.0)
            return String(format: "%.1f MB", fileSizeInMB)
        }
    }
}


struct ZipView: View {
    let image: ZipModel
    
    var formattedFileSize: String {
        guard let fileSize = image.fileSize else {
            return "Unknown"
        }
        
        if fileSize < 1000 {
            return "\(fileSize) KB"
        } else {
            let fileSizeInMB = Double(fileSize) / (1024.0 * 1024.0)
            return String(format: "%.1f MB", fileSizeInMB)
        }
    }

    
    var body: some View {
        ZStack {
            
            WebImage(url: URL(string: image.image))
                .resizable()
                .placeholder {
                   ProgressViewBlend()
                }
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .center)
                .cornerRadius(20)
              
            /*
            WebImage(url: URL(string: image.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .center)
                        .cornerRadius(20)
                case .failure:
                    Image(systemName: "xmark.circle")
                @unknown default:
                    EmptyView()
                }
            }
            */
        }
        .overlay {
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Text(image.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack {
                        Text(image.subtitle)
                            .font(.footnote)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack {
                        if let fileName = image.fileName {
                            Text("\(fileName)")
                                .font(.footnote)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    HStack {
                        Text(formattedFileSize)
                            .font(.footnote)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                .foregroundStyle(Color.primary)
              
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }
    }
}


struct ZipModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
    let fileURL: String
    let fileName: String?
    var fileSize: Int?
}


struct ZipData: Decodable {
    let image: String
    let title: String
    let subtitle: String
    let fileURL: String
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DownloadZipView()
//      
//    }
//}
