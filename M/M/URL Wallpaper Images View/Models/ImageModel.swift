//
//  ImageModel.swift
//  M
//
//  Created by Sean Kelly on 07/12/2023.
//

import SwiftUI


struct ImageModel: Identifiable, Hashable, Encodable {
    let id = UUID()
    let image: String
    var baseName: String {
        let fileName = URL(string: image)?.deletingPathExtension().lastPathComponent ?? ""
        return fileName
    }
    var isNew: Bool = false
}

