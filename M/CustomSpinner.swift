//
//  CustomSpinner.swift
//  M
//
//  Created by Sean Kelly on 29/12/2023.
//

import SwiftUI

struct CustomSpinner: View {
    // MARK: - Properties
    @State private var showSpinner:Bool = false
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    // MARK: - Body
    var body: some View {
        ZStack{
            VStack{
             
                if showSpinner{
                    Circle()
                        .trim(from: 0.0,to: spinnerLength)
                        .stroke(LinearGradient(colors: [.primary], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 4.0,lineCap: .round,lineJoin:.round))
                        .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true))
                        .frame(width: 20,height: 20)
                        .rotationEffect(Angle(degrees: Double(degree)))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear{
                            degree = 270 + 360
                            spinnerLength = 0
                        }
                }
            }
            .onAppear{
                showSpinner.toggle()
            }
        }
    }
}



#Preview {
    CustomSpinner()
}
