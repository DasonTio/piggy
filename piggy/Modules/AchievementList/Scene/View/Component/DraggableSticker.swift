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
    var widthBound: CGFloat
    var heightBound: CGFloat
    @State private var position: CGSize = .zero
    @State private var initialOffset: CGSize = .zero

    init(image: String, widthBound: CGFloat, heightBound: CGFloat, position: StickerPosition) {
        self.image = image
        self.widthBound = widthBound
        self.heightBound = heightBound
        self.position = .init(
            width: CGFloat(position.x),
            height: CGFloat(position.y)
        )
        self.initialOffset = .zero
        
    }
    
    var body: some View {
        GeometryReader{ geometry in
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100) // Adjust width as needed
                .position(
                    x: geometry.size.width / 2 + position.width,
                    y: geometry.size.height / 2 + position.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.position = CGSize(
                                width: self.initialOffset.width + value.translation.width,
                                height: self.initialOffset.height + value.translation.height
                            )
                        }
                        .onEnded{_ in
                            self.initialOffset = self.position
                        }
                )

        }
    }
}
