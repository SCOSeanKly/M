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
            .replacingOccurrences(of: "p_|w_|M099_|M199_|M299_|M399_|M499_", with: "", options: .regularExpression)
            .uppercased()

        return Text(updatedFileName)
            .font(.system(size: 10))
            .foregroundColor(.primary.opacity(0.5))
            .lineLimit(1)
            .multilineTextAlignment(.center)
    }
}


