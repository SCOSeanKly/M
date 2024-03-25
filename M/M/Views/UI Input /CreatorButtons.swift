//
//  CreatorButtons.swift
//  M
//
//  Created by Sean Kelly on 22/03/2024.
//

import SwiftUI

import SwiftUI

struct CreatorURLButtons: View {
    @StateObject var creatorLoader = CreatorGitHubLoader()
    @Environment(\.openURL) var openURL
    @State private var isButtonTapped: Bool = false
    @StateObject var viewModelData = DataViewModel()
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(creatorLoader.creatorInfos.sorted(by: { $0.name < $1.name }), id: \.self) { creatorInfo in

                    if let imageURL = URL(string: creatorInfo.imageURL) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                Button {
                                    if let socialURL = URL(string: creatorInfo.socialURL) {
                                        openURL(socialURL)
                                    }
                                    isButtonTapped.toggle()
                                } label: {
                                    VStack {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .padding(.top)
                                            
                                        // Assuming you have different icons for different social media platforms
                                        Image(creatorInfo.name == "widgy" ? "reddit" : "twitter")
                                                                       .resizable()
                                                                       .aspectRatio(contentMode: .fill)
                                                                       .frame(width: 20, height: 20)
                                                                       .clipShape(Circle())
                                                                       .offset(x: 10.0, y: -20)
                                            
                                        Text(creatorInfo.name)
                                            .font(.system(size: 8, weight: .regular, design: .rounded))
                                            .offset(y: -15)
                                    }
                                }

                                .frame(width: 78, height: 90)
                                .buttonStyle(.plain)
                            case .failure(let error):
                                // Handle failure
                                CreatorPlaceholder()
                            case .empty:
                                // Placeholder or loading indicator if needed
                                CreatorPlaceholder()
                            @unknown default:
                                // Handle unknown state
                                CreatorPlaceholder()
                            }
                        }
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: isButtonTapped)
        }
        .onAppear {
            // Fetch data when view appears
            creatorLoader.fetchCreators()
        }

    }
}

#if DEBUG
struct CreatorURLButtons_Previews: PreviewProvider {
    static var previews: some View {
        CreatorURLButtons()
    }
}
#endif
