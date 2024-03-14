//
//  NofilteredImagesButton.swift
//  M
//
//  Created by Sean Kelly on 14/03/2024.
//

import SwiftUI

struct NofilteredImagesButton: View {
    
    @Binding var searchText: String
    @Binding var isFiltering: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("No wallpapers found!")
            
            Button{
                searchText = ""
                isFiltering = false
                hideKeyboard()
                feedback()
            } label: {
                Text("OK")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(14)
                    .tint(.primary)
            }
            
            Spacer()
        }
    }
}
