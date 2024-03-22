//
//  Heart.swift
//  M
//
//  Created by Sean Kelly on 08/12/2023.
//

import SwiftUI

struct HeartAnimationView: View {
    @State private var hearts: [Heart] = []
    let symbolText: String

    var body: some View {
        ZStack {
            ForEach(hearts, id: \.id) { heart in
                Text(symbolText)
                    .font(.system(size: 16))
                    .position(heart.position)
                    .opacity(heart.opacity)
                    .scaleEffect(CGSize(width: heart.scale, height: heart.scale))
                    .rotationEffect(Angle(degrees: heart.rotation))
                    .animation(  Animation.linear(duration: heart.duration)
                        .repeatForever(autoreverses: false), value: heart.opacity)
            }
        }
        .onAppear {
            generateHearts()
        }
    }

    private func generateHearts() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            let newHeart = Heart(id: UUID(),
                                 position: randomPosition(),
                                 opacity: 1.0,
                                 duration: 3.0,
                                 scale: CGFloat.random(in: 0.5...1.5), // Random scale between 0.5 and 1.5
                                 rotation: Double.random(in: -10...10)) // Random rotation between -10 and 10 degrees
            hearts.append(newHeart)

            // Remove hearts that have completed their animation
            hearts.removeAll { $0.opacity <= 0.0 }

            // Update the position, opacity, scale, and rotation of each heart
            hearts.indices.forEach { index in
                withAnimation {
                    hearts[index].position.y -= 10
                    hearts[index].opacity -= 0.1
                }
            }
        }
    }

    private func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: 0..<UIScreen.main.bounds.width * 0.75)
        let y = CGFloat(140)
        return CGPoint(x: x, y: y)
    }
}

struct Heart: Identifiable {
    let id: UUID
    var position: CGPoint
    var opacity: Double
    var duration: Double
    var scale: CGFloat
    var rotation: Double
}

//struct HeartAnimationView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeartAnimationView()
//    }
//}
