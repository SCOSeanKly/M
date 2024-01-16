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
            .padding(8)
            .padding(.trailing, 4)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .pillModifier(obj: obj, normalScale: 1.0)
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
        HStack {
            ForEach(obj.appearance.avatarNames, id: \.self) { avatarName in
                AvatarButton(avatarName: avatarName, viewModelData: viewModelData, obj: obj)
                    .padding(.horizontal, 5)
            }
        }
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
                .frame(width: 184, height: 30, alignment: .center)
        }
    }
}
