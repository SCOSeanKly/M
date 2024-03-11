//
//  Chequerboard.swift
//  M
//
//  Created by Sean Kelly on 11/03/2024.
//

import SwiftUI

struct Checkerboard: Shape {
    
    
    let rows: Double
    let columns: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / rows
        let columnSize = rect.width / columns

        // loop over all rows and columns, making alternating squares colored
        for row in 0 ..< Int(rows) {
            for column in 0 ..< Int(columns) {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}

#Preview {
    Checkerboard(rows: 60, columns: 30)
        .fill(.gray.opacity(0.2))
               .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
               .ignoresSafeArea()
}
