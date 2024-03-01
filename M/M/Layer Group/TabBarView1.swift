//
//  TabBarView1.swift
//  CustomTabBar
//
//  Created by Pratik on 14/10/22.
//

import SwiftUI



struct TabBarView: View {
    
    @State private var selectedTab: Tab = .home
    @Binding var isShowingGradientView: Bool
 
    
    var body: some View {
        
        ZStack {
            
            TabsLayoutView(selectedTab: $selectedTab, isShowingGradientView: $isShowingGradientView)
        }
      
    }
}

 struct TabsLayoutView: View {
    @Binding var selectedTab: Tab
    @Namespace var namespace
     @Binding var isShowingGradientView: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
                
                
                HStack {
                    Spacer(minLength: 0)
                    
                    ForEach(Tab.allCases) { tab in
                        TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                            .frame(width: 45, height: 45, alignment: .center)
                        
                        Spacer(minLength: 0)
                    }
                }
                .padding(.bottom)
            }
            .frame(height: 90, alignment: .center)
            
        }
        .ignoresSafeArea()
       
    }
    
    
    
    private struct TabButton: View {
        let tab: Tab
             @Binding var selectedTab: Tab
             var namespace: Namespace.ID
             let backgroundColor = Color.init(white: 0.92)
        
        var body: some View {
            Button {
                withAnimation {
                    selectedTab = tab
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(backgroundColor)
                                    .shadow(color: .black.opacity(0.3), x: 0, y: 0, blur: 2)
                            }
                            .offset(y: -20)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                        .scaleEffect(isSelected ? 0.9 : 0.8)
                        .offset(y: isSelected ? -20 : 0)
                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 1.0, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home, game, apps, movie
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .game:
            return "gamecontroller.fill"
        case .apps:
            return "square.stack.3d.up.fill"
        case .movie:
            return "play.tv.fill"
        }
    }
}

/*
struct TabBarView1_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
*/
