//
//  ContentView.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct MockupMView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var viewModelData = DataViewModel()
    @StateObject var obj: Object
    @ObservedObject var newCreatorsViewModel = NewImagesViewModel()
    
    
    @State private var totalNewWallpapersCount = 0
    @State var buyClicked: Bool = false
    @State private var isZooming: Bool = false
    @State private var isShowingGradientView: Bool = false
    @State private var importedBackground: UIImage? = nil
    @State private var updates: [Update] = []
    @State private var showNewDataAlert = false
    @State var isScrolling = false
    @State var isScrollingSettings = false
    @State private var isTapped: Bool = false
    @State private var lastCheckedTime: Date?
    @State private var activeTab: Tab = .mockup
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    @State private var tabOpacity: CGFloat = 1
    let animationDuration: CGFloat = 0.2
    
    @AppStorage(IAP.purchaseID_UnlockPremium) private var showPremiumContent = false
    @AppStorage("showCoverFlow") private var showCoverFlow: Bool = false
    @AppStorage("showOnboarding") private var showOnboarding: Bool = true
    @AppStorage("previousData") var previousData: Data?
    
    var totalNewImagesCount: Int {
        newCreatorsViewModel.creators.reduce(0) { $0 + $1.newImagesCount }
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $activeTab) {
                    /// YOUR TAB VIEWS
                    if activeTab == .wallpapers {
                        URLImages(viewModelData: viewModelData, viewModelContent: viewModel, obj: obj, isShowingGradientView: $isShowingGradientView, showPremiumContent: $showPremiumContent, isZooming: $isZooming, importedBackground: $importedBackground, activeTab: $activeTab, isScrolling: $isScrolling, newCreatorsViewModel: newCreatorsViewModel)
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
            newCreatorsViewModel.reloadData()
            print("fetchData() &  newCreatorsViewModel.reloadData() exectuted. Total new \(totalNewImagesCount)")
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
                        ZStack {
                            Image(systemName: tab.rawValue)
                                .font(.title2)
                                .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                            
                            if tab == .wallpapers && totalNewImagesCount > 0 {
                              
                                Text("\(totalNewImagesCount)")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 8).weight(.bold))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background {
                                        Color.red
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                    }
                                    .offset(x: 10, y: -10)
                            }
                        }
                            
                        Text(tab.title)
                            .font(.caption2)
                            .textScale(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(activeTab == tab ? Color.blue : Color.gray.opacity(0.8))
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .contentShape(.rect)
                    /// You Can Also Use Button, If you Choose to
                    .onTapGesture {
                        isTapped.toggle()
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
        .sensoryFeedback(.selection, trigger: isTapped)
    }
    
    func fetchData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/SCOSeanKly/M_Resources/main/JSON/Update/update.json") else {
            print("Invalid URL")
            return
        }
        
        let currentTime = Date()
        
        // Check if last checked time is greater than 4 hours from the current time
        if let lastCheckedTime = self.lastCheckedTime,
           let timeInterval = Calendar.current.dateComponents([.hour], from: lastCheckedTime, to: currentTime).hour,
           timeInterval < 1 {
            print("Last checked less than 1 hour ago, skipping data fetch.")
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
                    
                    // Update the last checked time
                    self.lastCheckedTime = currentTime
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
