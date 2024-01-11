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
    var body: some View {
        HStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 30, height: 30)
                .overlay {
         
                    ProgressView()
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundColor(.primary)
                 
                }
            Text("Downloading")
                .padding(.horizontal)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 5)
        
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
                
            }
            Spacer()
        }
    }
}
