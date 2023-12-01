//
//  CustomPresentation.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI
import SwiftUIKit

enum DetentType {
    case small
    case medium
    case large

    var fractionValue: CGFloat {
        switch self {
        case .small:
            return 0.2
        case .medium:
            return 0.4
        case .large:
            return 0.995
        }
    }
}

extension View {
    func customPresentationWithBlur(detent: DetentType, detent2: DetentType, blurRadius: CGFloat, backgroundColorOpacity: Double) -> some View {
        self.presentationDetents([
            .fraction(detent.fractionValue),
            .fraction(detent2.fractionValue)
          
            
        ])
        .customPresentationDetents(
            undimmed: [
                .fraction(detent.fractionValue),
                .fraction(detent2.fractionValue)
            ],
            largestUndimmed: .fraction(detent2.fractionValue)
        )
        .presentationBackground {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: blurRadius, opaque: true)
                .background(Color.primary.opacity(backgroundColorOpacity).colorInvert())
        }
        .presentationCornerRadius(15)
        .presentationDragIndicator(.visible)
        .ignoresSafeArea()
    }
    
    
    // Overload the function with a version that accepts only one fraction
    func customPresentationWithBlur(detent: DetentType, blurRadius: CGFloat, backgroundColorOpacity: Double) -> some View {
        self.customPresentationWithBlur(detent: detent, detent2: detent, blurRadius: blurRadius, backgroundColorOpacity: backgroundColorOpacity)
    }
    
    func customPresentationWithPrimaryBackground(detent: DetentType, detent2: DetentType, backgroundColorOpacity: Double) -> some View {
        self.presentationDetents([
            .fraction(detent.fractionValue),
            .fraction(detent2.fractionValue)
        ])
        .customPresentationDetents(
            undimmed: [
                .fraction(detent.fractionValue),
                .fraction(detent2.fractionValue)
            ],
            largestUndimmed: .fraction(detent2.fractionValue)
        )
        .presentationBackground {
            Color.primary.opacity(backgroundColorOpacity).colorInvert()
        }
        .presentationCornerRadius(15)
        .presentationDragIndicator(.visible)
        .ignoresSafeArea()
    }
    
    // Overload the function with a version that accepts only one fraction
    func customPresentationWithPrimaryBackground(detent: DetentType, backgroundColorOpacity: Double) -> some View {
        self.customPresentationWithPrimaryBackground(detent: detent, detent2: detent, backgroundColorOpacity: backgroundColorOpacity)
    }
}

public extension View {
    
    func customPresentationDetents(
        undimmed detents: [PresentationDetentReference],
        largestUndimmed: PresentationDetentReference,
        selection: Binding<PresentationDetent>? = nil
    ) -> some View {
        self.modifier(
            PresentationDetentsViewModifier(
                presentationDetents: detents,
                largestUndimmed: largestUndimmed,
                selection: selection
            )
        )
    }
}


