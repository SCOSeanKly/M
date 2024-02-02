//
//  PersistentOverlays.swift
//  ShowBoard
//
//  Created by Sean Kelly on 20/06/2023.
//

import SwiftUI

extension View {

    func prefersPersistentSystemOverlaysHidden() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self
                .persistentSystemOverlays(.hidden)
                .statusBar(hidden: true)
                .ignoresSafeArea()
        } else {
            return self
        }
    }
}

