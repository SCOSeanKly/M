//
//  URLSaveStateViews.swift
//  M
//
//  Created by Sean Kelly on 22/11/2023.
//

import SwiftUI

struct SaveStateIdle: View {
    var body: some View {  Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 30, height: 30)
            .overlay {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundColor(.primary)
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(1.5)
            }
    }
}

struct SaveStateSaving: View {
    
    @Binding var progress: Double
    
    var body: some View {
        
        HStack {
            ProgressView()
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundColor(.primary)
                .scaleEffect(0.6)
            
            Text("Downloading ")
                .font(.system(size: 12))
                .foregroundColor(.primary)
            
            Text("\(String(format: "%.0f", progress * 100))%")
                .font(.system(size: 12))
                .frame(width: 40)
                .foregroundColor(.primary)
            
        }
        .frame(height: 30)
        .padding(.horizontal, 5)
        .background{
            ProgressBar(progress: $progress)
        }
    }
}

struct SaveStateSaved: View {
    var body: some View {
        HStack {
            Circle()
                .fill(.green)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "checkmark.circle")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundColor(.white)
                }
            Text("Saved")
                .font(.system(size: 12))
                .padding(.horizontal)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 5)
        
    }
}

struct LoadingImagesView: View {
    @Environment(\.openURL) var openURL
    @State private var isLoading = true
    @State private var showError = false
    @State private var countdown = 5 // Initial countdown value
    @State private var dismissAllText: Bool = false
    @StateObject var obj: Object
    let supportURL = URL(string: "https://t.me/+urxfCpCtJYllMjhk")!
    
    var body: some View {
        
        VStack {
            Spacer()
            
            if !dismissAllText {
                if !showError { // Only show these UI elements if error is not shown
                    HStack {
                        ProgressView()
                            .padding(.trailing, 5)
                        
                        if isLoading {
                            Text("Loading images...")
                                .font(.system(size: 12))
                        } else {
                            Text("Still loading (\(countdown))")
                                .font(.system(size: 12))
                                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                                    if countdown > 0 {
                                        countdown -= 1
                                    } else {
                                        showError = true
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                isLoading = false
            }
        }
        .alert(isPresented:$showError) {
            
            Alert(
                title: Text("⚠️ Loading failed!"),
                message: Text("Please contact support"),
                primaryButton: .default(Text("Contact Us")) {
                    dismissAllText = true
                    openURL(supportURL)
                    obj.appearance.showWallpapersView = false
                    
                    print("Contacting Support")
                },
                secondaryButton: .cancel() {
                    obj.appearance.showWallpapersView = false
                }
            )
            
        }
    }
}
