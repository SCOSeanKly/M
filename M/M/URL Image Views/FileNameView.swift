//
//  FileNameView.swift
//  M
//
//  Created by Sean Kelly on 31/01/2024.
//

import SwiftUI

struct FileNameView: View {
    let fileName: String

    var body: some View {
        let updatedFileName = fileName
            .replacingOccurrences(of: "p_", with: "")
            .replacingOccurrences(of: "w_", with: "")
            .uppercased()

        return Text(updatedFileName)
            .font(.system(size: 10))
            .foregroundColor(.primary.opacity(0.5))
            .lineLimit(1)
            .multilineTextAlignment(.center)
    }
}

