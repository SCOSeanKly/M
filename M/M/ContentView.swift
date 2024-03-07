//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

/*
 struct ContentView: View {
 
 @StateObject var viewModel = ContentViewModel()
 @StateObject var viewModelData = DataViewModel()
 @StateObject var obj: Object
 
 @State private var totalNewWallpapersCount = 0
 @State var buyClicked: Bool = false
 @State private var isZooming: Bool = false
 @State private var isShowingGradientView: Bool = false
 @State private var importedBackground: UIImage? = nil
 @State private var updates: [Update] = []
 @State private var showNewDataAlert = false
 let animationDuration: CGFloat = 0.2
 
 @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
 @AppStorage("showCoverFlow") private var showCoverFlow: Bool = false
 @AppStorage("showOnboarding") private var showOnboarding: Bool = true
 @AppStorage("previousData") var previousData: Data?
 
 
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
 MockupView(viewModel: viewModel, obj: obj, viewModelData: viewModelData, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked, isZooming: $isZooming, showCoverFlow: $showCoverFlow, showOnboarding: $showOnboarding, isShowingGradientView: $isShowingGradientView)
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
 */





struct MockupMView: View {
    /// View Properties
    @State private var activeTab: Tab = .mockup
    /// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    @State private var tabOpacity: CGFloat = 1
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var viewModelData = DataViewModel()
    @StateObject var obj: Object
    
    @State private var totalNewWallpapersCount = 0
    @State var buyClicked: Bool = false
    @State private var isZooming: Bool = false
    @State private var isShowingGradientView: Bool = false
    @State private var importedBackground: UIImage? = nil
    @State private var updates: [Update] = []
    @State private var showNewDataAlert = false
    let animationDuration: CGFloat = 0.2
    
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    @AppStorage("showCoverFlow") private var showCoverFlow: Bool = false
    @AppStorage("showOnboarding") private var showOnboarding: Bool = true
    @AppStorage("previousData") var previousData: Data?
    @State var isScrolling = false
    @State var isScrollingSettings = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $activeTab) {
                    /// YOUR TAB VIEWS
                    if activeTab == .wallpapers {
                        URLImages(viewModelData: viewModelData, viewModelContent: viewModel, obj: obj, isShowingGradientView: $isShowingGradientView, showPremiumContent: $showPremiumContent, isZooming: $isZooming, importedBackground: $importedBackground, activeTab: $activeTab, isScrolling: $isScrolling)
                            .setUpTab(.wallpapers)
                    }
                    
                    if activeTab == .mockup {
                        MockupView(viewModel: viewModel, obj: obj, viewModelData: viewModelData, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked, isZooming: $isZooming, showCoverFlow: $showCoverFlow, showOnboarding: $showOnboarding, isShowingGradientView: $isShowingGradientView, isScrollingSettings: $isScrollingSettings)
                            .setUpTab(.mockup)
                    }
                    
                    if activeTab == .creator {
                        GradientView(isShowingGradientView: $isShowingGradientView, importedBackground: $importedBackground, activeTab: $activeTab)
                            .setUpTab(.creator)
                            .onAppear{
                                isShowingGradientView.toggle()
                            }
                    }
                    if activeTab == .settings {
                        ApplicationSettings(obj: obj, showPremiumContent: $showPremiumContent, buyClicked: $buyClicked, showCoverFlow: $showCoverFlow, showOnboarding: $showOnboarding, isScrollingSettings: $isScrollingSettings)
                            .setUpTab(.settings)
                    }
                }
            }
            
          
                CustomTabBar()
                   
          
               
        }
        .sheet(isPresented: $showNewDataAlert) {
            NewsView(showNewDataAlert: $showNewDataAlert, updates: $updates)
        }
        .onAppear {
            fetchData()
        }
        .onChange(of: activeTab) {
            fetchData()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach($allTabs) { $animatedTab in
                    let tab = animatedTab.tab
                    
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.title2)
                            .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                        
                        Text(tab.title)
                            .font(.caption2)
                            .textScale(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .contentShape(.rect)
                    /// You Can Also Use Button, If you Choose to
                    .onTapGesture {
                        withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                            activeTab = tab
                            animatedTab.isAnimating = true
                        }, completion: {
                            var trasnaction = Transaction()
                            trasnaction.disablesAnimations = true
                            withTransaction(trasnaction) {
                                animatedTab.isAnimating = nil
                            }
                        })
                    }
                }
            }
            .background(.bar)
            .offset(y: isShowingGradientView ? UIScreen.main.bounds.height * 0.25 : 0)
            .opacity(isScrolling || isScrollingSettings ? 0.4 : 1)
            .animation(.bouncy, value: isShowingGradientView || isScrolling || isScrollingSettings)
        }
        
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

