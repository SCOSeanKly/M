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
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                ProgressView()
                    .padding(.trailing, 5)
                
                Text("Loading images...")
                    .font(.system(size: 12))
                
            }
            Spacer()
        }
    }
}
