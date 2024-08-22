//
//  View+Extensions.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation
import SwiftUI


extension View {
    
    @ViewBuilder
    func viewBorder(color: Color = .black, radius: CGFloat = 0.4, offset: CGFloat) -> some View {
        let dir = [
            [0,0],
            [0,1],
            [0,-1],
            [1,0],
            [-1,0],
            [1,1],
            [1,-1],
            [-1,1],
            [-1,-1]
        ]
        
        self
            .overlay(
                ForEach(dir.indices, id: \.self) { index in
                    let direction = dir[index]
                    let x = CGFloat(direction[0])
                    let y = CGFloat(direction[1])
                    
                    self.shadow(color: color, radius: radius, x: x * offset, y: y * offset)
                }
            )
    }
}
