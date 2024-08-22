//
//  AchievementStickerEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 19/08/24.
//

import Foundation

internal struct StickerPosition{
    var x: Float
    var y: Float
}

internal struct AchievementStickerEntity: Identifiable{
    let id: String
    let image: String
    var position: StickerPosition
    let scale: Float?
    let isShowed: Bool
    
    init(id: String, image: String, position: StickerPosition, scale: Float? = 1.00, isShowed: Bool = false) {
        self.id = id
        self.image = image
        self.position = position
        self.scale = scale
        self.isShowed = isShowed
    }
}
