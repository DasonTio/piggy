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
    
    func customSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        content: @escaping () -> SheetContent
    ) -> some View {
        GeometryReader{geometry in
            let widthPercentage = geometry.size.width / 100
            let heightPercentage = geometry.size.height / 100
            
            ZStack {
                self
                if isPresented.wrappedValue {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented.wrappedValue = false
                        }
                    content()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Color.tint2
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 2) // Add border with corner radius
                                )
                                .shadow(radius: 20)
                        )
                        .padding(.horizontal, widthPercentage * 10)
                        .padding(.vertical, heightPercentage * 10)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                }
            }
        }
        
    }
}
