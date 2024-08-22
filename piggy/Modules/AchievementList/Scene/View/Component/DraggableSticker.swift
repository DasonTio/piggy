//
//  DraggableSticker.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation
import SwiftUI

struct DraggableSticker: View {
    var image: String
    @Binding var position: StickerPosition
    @State private var coordinate: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    
    
    var body: some View {
        GeometryReader{ geometry in
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100) // Adjust width as needed
                .position(
                    x: geometry.size.width / 2 + CGFloat(position.x),
                    y: geometry.size.height / 2 + CGFloat(position.y)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.position.x = Float(CGFloat(self.initialOffset.width + value.translation.width))
                            self.position.y = Float(CGFloat(self.initialOffset.height + value.translation.height))
                            self.coordinate = CGSize(
                                width: self.initialOffset.width + value.translation.width,
                                height: self.initialOffset.height + value.translation.height
                            )
                        }
                        .onEnded{_ in
                            self.initialOffset = self.coordinate
                            self.position.x = Float(self.coordinate.width)
                            self.position.y = Float(self.coordinate.height)
                        }
                )

        }
    }
}
