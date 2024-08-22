//
//  AchievementStickerLocalEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

import Foundation
import SwiftData

@Model
internal class StickerPositionLocalEntity{
    let x: Float
    let y: Float
    
    init(x: Float = 0.0, y: Float = 0.0) {
        self.x = x
        self.y = y
    }
}

@Model
internal class AchievementStickerLocalEntity{
    @Attribute(.unique) var id: String
    var image: String
    var position: StickerPositionLocalEntity
    var scale: Float?
    var isShowed: Bool
    
    init(id: String, image: String, position: StickerPositionLocalEntity, scale: Float? = 1.00, isShowed: Bool = false) {
        self.id = id
        self.image = image
        self.position = position
        self.scale = scale
        self.isShowed = isShowed
    }
}


extension AchievementStickerLocalEntity{
    func toDomain() -> AchievementStickerEntity {
        return .init(
            id: self.id,
            image: self.image,
            position: self.position.toDomain(),
            scale: self.scale,
            isShowed: self.isShowed
        )
    }
}

extension StickerPositionLocalEntity{
    func toDomain() -> StickerPosition{
        return .init(
            x: self.x,
            y: self.y
        )
    }
}
