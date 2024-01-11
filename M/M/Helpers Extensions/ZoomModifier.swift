//
//  ZoomModifier.swift
//  M
//
//  Created by Sean Kelly on 03/11/2023.
//

import SwiftUI

struct ZoomModifier: ViewModifier {
    enum ZoomState {
        case inactive
        case active(scale: CGFloat)

        var scale: CGFloat {
            switch self {
            case .active(let scale):
                return scale
            default:
                return 1.0
            }
        }
    }
    
    var minimum: CGFloat = 1.0
    var maximum: CGFloat = 3.0
    
    @GestureState private var zoomState = ZoomState.inactive
    @StateObject var obj: Object
    
    var scale: CGFloat {
        return obj.appearance.currentScale * zoomState.scale
    }
    
    var pinchGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomState) { value, state, transaction in
                state = .active(scale: value)
                obj.appearance.isZoomActive = true // Set isZoomActive to true when zoom is active
            }.onEnded { value in
                var newValue = self.obj.appearance.currentScale * value
                if newValue <= minimum { newValue = minimum }
                if newValue >= maximum { newValue = maximum }
                self.obj.appearance.currentScale = newValue
                obj.appearance.isZoomActive = false // Set isZoomActive to false when zoom ends
            }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(pinchGesture)
            .animation(.easeInOut, value: scale)
    }
}

struct ZoomActiveKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isZoomActive: Bool {
        get { self[ZoomActiveKey.self] }
        set { self[ZoomActiveKey.self] = newValue }
    }
}
