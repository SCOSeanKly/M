//
//  SearchBarView.swift
//  M
//
//  Created by Sean Kelly on 14/03/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isFiltering: Bool
    @StateObject var keyboardObserver: KeyboardObserver
    @StateObject var viewModelData: DataViewModel
    @Binding var randomURLWallpaperImageName: String

    
    
    var body: some View {
        ZStack {
            TextField("Search \(viewModelData.images.count) Wallpapers...", text: $searchText)
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(14)
                .padding(.horizontal)
                .font(.system(size: 14, design: .rounded))
                .keyboardType(.numberPad)
                .onChange(of: searchText) {
                    isFiltering = !searchText.isEmpty
                    if searchText.isEmpty {
                        hideKeyboard()
                    }
                }
            
            HStack {
                Spacer()
                if isFiltering || searchText != "" {
                    Button(action: {
                        hideKeyboard()
                        feedback()
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .padding()
                    }
                }
            }
            .padding(.trailing, 10)
        }
        .foregroundColor(.primary)
        .padding(.vertical, 5)
        .frame(height: 50)
        .onReceive(keyboardObserver.$isKeyboardPresented) { isKeyboardPresented in
            
            print("Keyboard presented: \(isKeyboardPresented)")
        }
    }
}


// KeyboardObserver class to handle keyboard observation
class KeyboardObserver: ObservableObject {
    @Published var isKeyboardPresented = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        isKeyboardPresented = true
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardPresented = false
    }
}
