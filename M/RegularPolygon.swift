//
//  RegularPolygon.swift
//  M
//
//  Created by Sean Kelly on 04/01/2024.
//

import SwiftUI

struct HexagonGrid: View {
    let rows: Int
    let columns: Int

    var body: some View {
        VStack(spacing: -HexagonConstants.verticalSpacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: HexagonConstants.horizontalSpacing) {
                    Spacer().frame(width: row % 2 == 0 ? 0 : HexagonConstants.horizontalSpacing * 2.69) // Offset every second row
                    ForEach(0..<self.columns, id: \.self) { column in
                        Hexagon()
                    }
                }
            }
        }
    }
}


struct Hexagon: View {
    var body: some View {
        PolygonShape(sides: 6)
            .foregroundColor(.clear)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 50, opaque: true)
            }
            .clipShape(PolygonShape(sides: 6))
            .frame(width: HexagonConstants.size, height: HexagonConstants.size)
    }
}

struct PolygonShape: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        guard sides >= 3 else { return Path() }

        var path = Path()
        let angle = .pi * 2 / CGFloat(sides)

        for side in 0..<sides {
            let x = rect.midX + cos(angle * CGFloat(side)) * rect.width / 2
            let y = rect.midY + sin(angle * CGFloat(side)) * rect.height / 2
            let point = CGPoint(x: x, y: y)

            if side == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}

struct HexagonConstants {
    static let size: CGFloat = 26
    static let verticalSpacing: CGFloat = 37.5 // Adjust as needed
    static let horizontalSpacing: CGFloat = 15.0 // Adjust as needed
}

struct ContentView2: View {
    
    var body: some View {
        HexagonGrid(rows: 22, columns: 7)
            .offset(x: -20,y: 500)
         
    }
}


#Preview {
    ContentView2()
}
