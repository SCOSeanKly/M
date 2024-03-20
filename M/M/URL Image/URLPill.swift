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
                                                            Text("⚠️")
                                                        case .empty:
                                                          ProgressView()
                                                                .scaleEffect(0.5)
                                                        @unknown default:
                                                            Text("⚠️")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .opacity(obj.appearance.showPill ? 1 : 0)
                                    
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(creatorLoader.creatorInfos, id: \.self) { creatorInfo in
                                                if let imageURL = URL(string: creatorInfo.imageURL) {
                                                    AsyncImage(url: imageURL) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            Button {
                                                                isTapped.toggle()
                                                                viewModelData.creatorName = creatorInfo.name
                                                                withAnimation(.bouncy) {
                                                                    obj.appearance.showPill.toggle()
                                                                    viewModelData.loadImages()
                                                                }
                                                                
                                                            } label: {
                                                                image
                                                                    .resizable()
                                                                    .frame(width: 30, height: 30)
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .clipShape(Circle())
                                                                    .padding(.horizontal, 4)
                                                            }
                                                            .sensoryFeedback(.selection, trigger: isTapped)
                                                        case .failure(let error):
                                                            Text("⚠️")
                                                        case .empty:
                                                          ProgressView()
                                                                .scaleEffect(0.5)
                                                        @unknown default:
                                                            Text("⚠️")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.trailing, 30)
                                    }
                                    .opacity(obj.appearance.showPill ? 0 : 1)
                                    .frame(width: UIScreen.main.bounds.width * 0.65, height: 30, alignment: .center)
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
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 30, alignment: .center)
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



//MARK: Working from WWallpaperURLData
/*
 import SwiftUI

 struct URLPill: View {
     
     @StateObject var obj: Object
     @State private var isTapped: Bool = false
     @State private var isTappedProminent: Bool = false
     @StateObject var viewModelData: DataViewModel
     @StateObject var newCreatorsViewModel: NewImagesViewModel
     @StateObject var imageFetcher = CreatorClass()
     
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
                                     Circle()
                                         .fill(.clear)
                                         .frame(width: 30, height: 30)
                                         .overlay {
                                             Image(uiImage: imageFetcher.cachedImages[viewModelData.creatorName] ?? UIImage())
                                                 .resizable()
                                                 .frame(width: 30, height: 30)
                                                 .aspectRatio(contentMode: .fill)
                                                 .clipShape(Circle())
                                         }
                                         .opacity(obj.appearance.showPill ? 1 : 0)
                                     
                                     Group {
                                         ScrollView(.horizontal, showsIndicators: false) {
                                             HStack {
                                                 ForEach(imageFetcher.userURLs.keys.sorted(), id: \.self) { username in
                                                     if imageFetcher.cachedImages[username] != nil {
                                                         if let cachedImage = imageFetcher.cachedImages[username] {
                                                             Button {
                                                                 isTapped.toggle()
                                                                 viewModelData.creatorName = username
                                                                 withAnimation(.bouncy) {
                                                                     obj.appearance.showPill.toggle()
                                                                     viewModelData.loadImages()
                                                                 }
                                                             } label: {
                                                                 Image(uiImage: cachedImage)
                                                                     .resizable()
                                                                     .frame(width: 30, height: 30)
                                                                     .aspectRatio(contentMode: .fill)
                                                                     .clipShape(Circle())
                                                                 
                                                             }
                                                             .sensoryFeedback(.selection, trigger: isTapped)
                                                             .overlay {
                                                                 if let creatorName = newCreatorsViewModel.creators.first(where: { $0.name == username }),
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
                                                         }
                                                     }
                                                 }
                                             }
                                         }
                                         .onAppear {
                                             imageFetcher.fetchImages {
                                             }
                                             imageFetcher.refreshCache {
                                                 print("Cache refreshed")
                                             }
                                         }
                                         .opacity(obj.appearance.showPill ? 0 : 1)
                                         .frame(width: UIScreen.main.bounds.width * 0.65, height: 30, alignment: .center)
                                         .cornerRadius(100)
                                     }
                                     
                                 }
                                 .frame(width: 200, alignment: .leading)
                                 .padding(.leading, 38)
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
                                     .frame(width: UIScreen.main.bounds.width * 0.6, height: 30, alignment: .center)
                             }
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


 */
