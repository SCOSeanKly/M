//
//  CustomSlider.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct CustomSlider<T: BinaryFloatingPoint>: View {
    @Binding var value: T
    let inRange: ClosedRange<T>
    let activeFillColor: Color
    let fillColor: Color
    let emptyColor: Color
    let height: CGFloat
    let onEditingChanged: (Bool) -> Void

    // private variables
    @State private var localRealProgress: T = 0
    @State private var localTempProgress: T = 0
    @GestureState private var isActive: Bool = false

    var body: some View {
        GeometryReader { bounds in
            ZStack {
                VStack {
                    ZStack(alignment: .center) {
                        Capsule()
                            .fill(emptyColor)

                        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.15), Color.white.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                            .cornerRadius(100)

                        Capsule()
                            .fill(isActive ? activeFillColor : fillColor)
                            .mask({
                                HStack {
                                    Rectangle()
                                        .frame(width: max(bounds.size.width * CGFloat((localRealProgress + localTempProgress)), 0), alignment: .leading)
                                    Spacer(minLength: 0)
                                }
                            })

                        ZStack {
                            
                            Circle()
                                .frame(width: 100)
                                .foregroundColor(.white.opacity(0.00001))
                            
                            Circle()
                                .frame(width: 26)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.15), radius: 1.25, x: 1, y: 1)
                            
                            Circle()
                                .frame(width: 22)
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.1), .white.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())

                        }
                        .frame(height: height * 5.0, alignment: .center)
                        .position(x: bounds.size.width * CGFloat(localRealProgress), y: bounds.size.height / 2)
                        .gesture(DragGesture(minimumDistance: 0)
                            .updating($isActive) { value, state, transaction in
                                    state = true
                            }
                            .onChanged { gesture in
                             
                                    let sliderWidth = max(bounds.size.width, 1) // Avoid division by zero
                                    let percentage = min(max(gesture.location.x / sliderWidth, 0), 1)
                                    updateSlider(percentage: T(percentage))
                            }
                        )
                    }
                    .frame(width: bounds.size.width, alignment: .center)
                }
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            .onChange(of: value) {

                    localRealProgress = getPrgPercentage(value)
                    onEditingChanged(isActive)

            }
            .onAppear {
             
                    localRealProgress = getPrgPercentage(value)
               
            }
        }
        .frame(height: height)
        .padding(.leading, 10)
    }

    private func setSliderValue(_ newValue: T) {
        value = max(min(newValue, inRange.upperBound), inRange.lowerBound)
    }

    private func updateSlider(percentage: T) {
        localRealProgress = percentage
        setSliderValue(getPrgValue())
    }

    private func getPrgPercentage(_ value: T) -> T {
        let range = inRange.upperBound - inRange.lowerBound
        if range != 0 {
            let correctedStartValue = value - inRange.lowerBound
            let percentage = correctedStartValue / range
            return percentage
        } else {
            return 0
        }
    }

    private func getPrgValue() -> T {
        return ((localRealProgress + localTempProgress) * (inRange.upperBound - inRange.lowerBound)) + inRange.lowerBound
    }
}
