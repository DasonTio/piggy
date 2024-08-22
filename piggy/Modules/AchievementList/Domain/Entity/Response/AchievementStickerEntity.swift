//
//  AchievementStickerEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 19/08/24.
//

import Foundation

internal struct StickerPosition{
    let x: Float
    let y: Float
}

internal struct AchievementStickerEntity: Identifiable{
    let id: String
    let image: String
    let position: StickerPosition
    let scale: Float?
    
    init(id: String, image: String, position: StickerPosition, scale: Float? = 1.00) {
        self.id = id
        self.image = image
        self.position = position
        self.scale = scale
    }
}
