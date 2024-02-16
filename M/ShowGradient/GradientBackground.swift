//
//  GradientBackground.swift
//  M
//
//  Created by Sean Kelly on 16/02/2024.
//

import SwiftUI

struct GradientBackground: View {
    let gradientColors: [Color]
    @Binding var refreshButtonTapped: Bool
    let gradientStyle: GradientView.GradientStyle
    
    @State private var animationDuration: Double = 0.5
    @State private var center: UnitPoint = .zero
    @State private var startRadius: CGFloat = 0.0
    @State private var endRadius: CGFloat = 0.0
    @State private var startAngle: Angle = .zero
    @State private var endAngle: Angle = .zero
    @State private var startPoint: UnitPoint = .topLeading
    @State private var endPoint: UnitPoint = .bottomTrailing
    @Binding var gradientScale: CGFloat
    @Binding var gradientRotation: Angle
    @Binding var gradientBlur: CGFloat
    @Binding var gradientOffsetX: CGFloat
    @Binding var gradientOffsetY: CGFloat
    @Binding var importedBackground: UIImage?
    
    @Binding var pixellate: CGFloat
    @Binding var speed: CGFloat
    @Binding var amplitude: CGFloat
    @Binding var frequency: CGFloat
    
    let startDate: Date = .init()
    
    @Binding var gradientHue: CGFloat
    @Binding var gradientSaturation: CGFloat
    @Binding var gradientBrightness: CGFloat
    @Binding var gradientContrast: CGFloat
    
    var body: some View {
        let gradient: AnyView
        switch gradientStyle {
        case .linear:
            gradient = AnyView(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: startPoint, endPoint: endPoint)
            )
        case .radial:
            gradient = AnyView(
                RadialGradient(gradient: Gradient(colors: gradientColors), center: center, startRadius: startRadius, endRadius: endRadius)
            )
        case .angular:
            gradient = AnyView(
                AngularGradient(gradient: Gradient(colors: gradientColors), center: center, startAngle: startAngle, endAngle: endAngle)
            )
        }
        
        return Group {
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                ZStack {
                    gradient.animation(.linear(duration: animationDuration))
                    
                    if let background = importedBackground {
                        Image(uiImage: background)
                            .resizable()
                    }
                }
                .distortionEffect(
                    .init(
                        function: .init(library: .default, name: "wave"),
                        arguments: [
                            .float(0),
                            .float(speed),
                            .float(frequency),
                            .float(amplitude)
                        ]
                    ),
                    maxSampleOffset: .zero
                )
            }
        }
        .id(refreshButtonTapped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hueRotation(Angle(degrees: gradientHue))
        .saturation(gradientSaturation)
        .contrast(gradientContrast)
        .brightness(gradientBrightness)
        .scaleEffect(gradientScale)
        .rotationEffect(gradientRotation)
        .offset(x: gradientOffsetX, y: gradientOffsetY)
        .clipShape(Rectangle())
        .distortionEffect(
            .init(
                function: .init(library: .default, name: "pixellate"),
                arguments: [.float(pixellate)]
            ),
            maxSampleOffset: .zero
        )
        .onAppear {
            animationDuration = 1.0
            updateGradientProperties()
        }
        .onChange(of: refreshButtonTapped) {
            updateGradientProperties()
        }
    }
    
    private func updateGradientProperties() {
        center = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
        startRadius = CGFloat.random(in: 0...500)
        endRadius = CGFloat.random(in: startRadius...1000)
        startAngle = Angle(degrees: Double.random(in: 0...360))
        endAngle = Angle(degrees: Double.random(in: startAngle.degrees...startAngle.degrees + 360))
        startPoint = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
        endPoint = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
    }
}