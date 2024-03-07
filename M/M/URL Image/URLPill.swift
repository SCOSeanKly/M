//
//  URLPill.swift
//  M
//
//  Created by Sean Kelly on 15/01/2024.
//

import SwiftUI

struct URLPill: View {
    
    @StateObject var obj: Object
    @State private var isTapped: Bool = false
    @State private var isTappedProminent: Bool = false
    @StateObject var viewModelData: DataViewModel
    
    var body: some View {
        
        ZStack {
            
            HStack {
                Text(viewModelData.creatorName == "widgy" ? "Widgets" : "Wallpapers")
                    .font(.largeTitle.bold())
                    .onChange(of: viewModelData.creatorName) {
                        viewModelData.forceRefresh.toggle()
                    }
                    .opacity(obj.appearance.showPill ? 1: 0)
                    .offset(x: obj.appearance.showPill ?  0 : -100)
                
                Spacer()
            }
            
            HStack {
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .fill(.blue.opacity(0.5))
                            .frame(width: 30, height: 30)
                            .overlay {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.system(.body, design: .rounded).weight(.medium))
                                    .foregroundColor(.white)
                            }
                            .overlay(alignment: .leading) {
                                ZStack(alignment: .leading) {
                                    URLTextViewOne(viewModelData: viewModelData)
                                        .opacity(obj.appearance.showPill ? 1 : 0)
                                    
                                    URLTextViewTwo(obj: obj, viewModelData: viewModelData)
                                        .opacity(obj.appearance.showPill ? 0 : 1)
                                }
                                .frame(width: 200, alignment: .leading)
                                .padding(.leading, 38)
                            }
                        
                        if obj.appearance.showPill {
                            URLTextViewOneSizer()
                        } else {
                            URLTextViewTwoSizer(obj: obj)
                        }
                    }
                    .sensoryFeedback(.selection, trigger: isTapped)
                    .sensoryFeedback(.success, trigger: isTappedProminent)
                    .onTapGesture {
                        withAnimation(.bouncy){
                            isTapped.toggle()
                            obj.appearance.showPill.toggle()
                        }
                    }
                    .pillModifier(obj: obj, normalScale: 1.0)
                }
            }
        }
    }
}

private struct URLTextViewOne: View {
    @StateObject var viewModelData: DataViewModel
    
    var body: some View {
        Circle()
            .fill(.clear)
            .frame(width: 30, height: 30)
            .overlay {
                Image(viewModelData.creatorName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
    }
}
 
private struct URLTextViewOneSizer: View {
    
    var body: some View {
        VStack {
            Circle()
                .fill(.clear)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "circle")
                        .font(.system(.body, design: .rounded).weight(.medium))
                }
                .foregroundColor(.clear)
        }
    }
}

private struct URLTextViewTwo: View {
    @StateObject var obj: Object
    @StateObject var viewModelData: DataViewModel
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(obj.appearance.avatarNames, id: \.self) { avatarName in
                    AvatarButton(avatarName: avatarName, viewModelData: viewModelData, obj: obj)
                        .padding(.horizontal, 4)
                }
            }
          
        }
        .frame(width: UIScreen.main.bounds.width * 0.65, height: 30, alignment: .center)
        .cornerRadius(100)
        
    }
}

private struct AvatarButton: View {
    let avatarName: String
    @ObservedObject var viewModelData: DataViewModel
    @ObservedObject var obj: Object
    
    var body: some View {
        AvatarAnimatedButton(action: {
            viewModelData.creatorName = avatarName
            withAnimation(.bouncy) {
                obj.appearance.showPill.toggle()
                viewModelData.loadImages()
            }
        }, avatarName: avatarName, rotationAntiClockwise: false, rotationDegrees: 720, color: .primary, allowRotation: false)
    }
}


private struct URLTextViewTwoSizer: View {
    @StateObject var obj: Object
    
    var body: some View {
        Group {
            Color.clear
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 30, alignment: .center)
        }
    }
}


struct AvatarAnimatedButton: View {
    
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isAnimating: Bool = false
    @State private var isTapped: Bool = false
    
    var action: () -> Void
    var avatarName: String
    var rotationAntiClockwise: Bool
    var rotationDegrees: Double
    var color: Color
    var allowRotation: Bool
    
    
    
    var body: some View {
        
        Button {
            isTapped.toggle()
            isAnimating.toggle()
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isAnimating.toggle()
            }
            
        } label: {
            if isAnimating {
                Image(avatarName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .rotationEffect(rotationAngle)
                    .animation(.easeInOut(duration: 1.5), value: rotationAngle)
                    .onAppear {
                        if allowRotation {
                            rotationAngle = .degrees(rotationAntiClockwise ? -rotationDegrees : rotationDegrees)
                        }
                    }
                    .onDisappear {
                        rotationAngle = .degrees(0)
                    }
            } else {
                Image(avatarName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }
        .tint(color)
        .sensoryFeedback(.selection, trigger: isTapped)
        
    }
}


