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
    @StateObject var viewModelData: DataViewModel
    @StateObject var newCreatorsViewModel: NewImagesViewModel
    @StateObject var creatorLoader = CreatorGitHubLoader()
    @Binding var wallpaperScollViewPosition: Int?
    
    
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
                
                CreatorImage(obj: obj, creatorLoader: creatorLoader, viewModelData: viewModelData, newCreatorsViewModel: newCreatorsViewModel)
                
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
                                    Circle()
                                        .fill(.clear)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            // Display the image of the selected creator
                                            if let creatorInfo = creatorLoader.creatorInfos.first(where: { $0.name == viewModelData.creatorName }) {
                                                if let imageURL = URL(string: creatorInfo.imageURL) {
                                                    AsyncImage(url: imageURL) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .frame(width: 30, height: 30)
                                                                .aspectRatio(contentMode: .fill)
                                                                .clipShape(Circle())
                                                        case .failure(let error):
                                                            CreatorPlaceholder()
                                                        case .empty:
                                                            CreatorPlaceholder()
                                                        @unknown default:
                                                            CreatorPlaceholder()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .opacity(obj.appearance.showPill ? 1 : 0)
                                    
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(creatorLoader.creatorInfos.filter { $0.name != viewModelData.creatorName }.sorted(by: { $0.name < $1.name }), id: \.self) { creatorInfo in
                                                if let imageURL = URL(string: creatorInfo.imageURL) {
                                                    AsyncImage(url: imageURL) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            Button {
                                                                isTapped.toggle()
                                                                viewModelData.creatorName = creatorInfo.name
                                                                viewModelData.loadImages()
                                                               
                                                                withAnimation(.bouncy) {
                                                                    obj.appearance.showPill.toggle()
                                                                }
                                                                
                                                            } label: {
                                                                image
                                                                    .resizable()
                                                                    .frame(width: 30, height: 30)
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .clipShape(Circle())
                                                                    .padding(.horizontal, 1)
                                                            }
                                                            .sensoryFeedback(.selection, trigger: isTapped)
                                                            .overlay {
                                                                if let creatorName = newCreatorsViewModel.creators.first(where: { $0.name == creatorInfo.name }),
                                                                   creatorName.newImagesCount > 0 {
                                                                    Text("\(creatorName.newImagesCount)")
                                                                        .foregroundStyle(.white)
                                                                        .font(.system(size: 6).weight(.bold))
                                                                        .padding(.horizontal, 3)
                                                                        .padding(.vertical, 1.5)
                                                                        .background {
                                                                            Color.red
                                                                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                                                        }
                                                                        .offset(x: 8, y: 10)
                                                                }
                                                            }
                                                            .padding(.horizontal, 4)
                                                        case .failure(let error):
                                                            CreatorPlaceholder()
                                                        case .empty:
                                                            CreatorPlaceholder()
                                                        @unknown default:
                                                            CreatorPlaceholder()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.trailing, 20)
                                    }
                                    .opacity(obj.appearance.showPill ? 0 : 1)
                                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .center)
                                    .cornerRadius(100)
                                }
                                .frame(width: 200, alignment: .leading)
                                .padding(.leading, 38)
                                .onAppear {
                                    // Fetch data when view appears
                                    creatorLoader.fetchCreators()
                                }
                            }
                        
                        if obj.appearance.showPill {
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
                        } else {
                            Group {
                                Color.clear
                                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .center) //MARK: adj
                            }
                        }
                    }
                    .sensoryFeedback(.selection, trigger: isTapped)
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


struct CreatorImage: View {
    @StateObject var obj: Object
    @StateObject var creatorLoader: CreatorGitHubLoader
    @StateObject var viewModelData: DataViewModel
    @StateObject var newCreatorsViewModel: NewImagesViewModel
    
    var body: some View {
        if let creatorInfo = creatorLoader.creatorInfos.first(where: { $0.name == viewModelData.creatorName }) {
            if let imageURL = URL(string: creatorInfo.imageURL) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay {
                                if let creatorName = newCreatorsViewModel.creators.first(where: { $0.name == creatorInfo.name }),
                                   creatorName.newImagesCount > 0 {
                                    Text("\(creatorName.newImagesCount)")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 6).weight(.bold))
                                        .padding(.horizontal, 3)
                                        .padding(.vertical, 1.5)
                                        .background {
                                            Color.red
                                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                        }
                                        .offset(x: 15, y: 22)
                                } else {
                                    Text("\(viewModelData.creatorName)")
                                        .font(.system(size: 8))
                                        .foregroundColor(.primary)
                                        .padding(4)
                                        .background(Color.primary.colorInvert())
                                        .cornerRadius(5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                             .stroke(Color.primary.opacity(0.4), lineWidth: 0.5)
                                        )
                                        .frame(width: 100)
                                        .offset(x: 15.0, y: 22.0)
                                }
                            }
                            .opacity(obj.appearance.showPill ? 0: 1)
                            .offset(x: obj.appearance.showPill ?  -100 : 0)
                    case .failure(let error):
                        CreatorPlaceholder()
                            .opacity(0.0)
                    case .empty:
                        CreatorPlaceholder()
                            .opacity(0.0)
                    @unknown default:
                        CreatorPlaceholder()
                            .opacity(0.0)
                    }
                }
            }
        }
    }
}
