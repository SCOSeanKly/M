//
//  OffsetReader.swift
//  M
//
//  Created by Sean Kelly on 07/12/2023.
//

import SwiftUI


// MARK: Offset Reader
extension View{
    @ViewBuilder
    func offset(completion: @escaping (CGRect)->())->some View{
        self
            .overlay {
                GeometryReader{
                    let rect = $0.frame(in: .named("SCROLLER"))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
