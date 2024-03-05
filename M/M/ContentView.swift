//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var viewModelData = DataViewModel()
    @StateObject var obj: Object
    @State private var totalNewWallpapersCount = 0
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    @State var buyClicked: Bool = false
    let animationDuration: CGFloat = 0.2
    @State private var isZooming: Bool = false
    @AppStorage("showCoverFlow") private var showCoverFlow: Bool = false
    @AppStorage("showOnboarding") private var showOnboarding: Bool = true
    @State private var isShowingGradientView: Bool = false
    @State private var importedBackground: UIImage? = nil
    
    @State private var updates: [Update] = []
    @AppStorage("previousData") var previousData: Data?
    @State private var showNewDataAlert = false
    
    
    var body: some View {
    
        ZStack {
            if obj.appearance.showWallpapersView {
                
                // MARK: Wallpaper View
                GeometryReader { geometry in
                    URLImages(viewModelData: viewModelData, viewModelContent: viewModel, obj: obj, isShowingGradientView: $isShowingGradientView, showPremiumContent: $showPremiumContent, isZooming: $isZooming, importedBackground: $importedBackground)
                        .opacity(geometry.frame(in: .global).midX >= UIScreen.main.bounds.width / 2 ? 1.0 : 0.0)
                        .onAppear {
                            let _ = IAP.shared
                        }
                        .rotation3DEffect(
                            Angle(degrees: obj.appearance.showWallpapersView ? -180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
                }
                
            } else {
                
                //MARK: Mockup View
                GeometryReader { geometry in
                    MockupView(viewModel: viewModel, obj: obj, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked, isZooming: $isZooming, showCoverFlow: $showCoverFlow, showOnboarding: $showOnboarding, isShowingGradientView: $isShowingGradientView, viewModelData: viewModelData)
                        .opacity(geometry.frame(in: .global).midX <= UIScreen.main.bounds.width / 2 ? 1.0 : 0.0)
                        .onAppear {
                            let _ = IAP.shared
                        }
                        .rotation3DEffect(
                            Angle(degrees: obj.appearance.showWallpapersView ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
                }
            }
        }
        .onAppear {
            fetchData()
        }
        .onChange(of: obj.appearance.showWallpapersView) {
            fetchData()
        }
        .sheet(isPresented: $showNewDataAlert) {
          NewsView(showNewDataAlert: $showNewDataAlert, updates: $updates)
        }
        .rotation3DEffect(
            Angle(degrees: obj.appearance.showWallpapersView ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.linear(duration: animationDuration), value: obj.appearance.showWallpapersView)
        
    }
    
    func fetchData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/Update/update.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let previousData = self.previousData, data != previousData {
                        print("JSON data changed, show alert")
                        self.showNewDataAlert = true
                    } else {
                        print("No new JSON data changes found")
                    }
                    
                    self.previousData = data
                    
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let updates = try decoder.decode([Update].self, from: data)
                    DispatchQueue.main.async {
                        self.updates = updates
                        // Print the fetched JSON data
                        print(updates)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}





