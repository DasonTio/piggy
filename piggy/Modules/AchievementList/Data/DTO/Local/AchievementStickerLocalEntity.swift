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
    
    init(id: String, image: String, position: StickerPositionLocalEntity, scale: Float? = 1.00) {
        self.id = id
        self.image = image
        self.position = position
        self.scale = scale
    }
}


extension AchievementStickerLocalEntity{
    func toDomain() -> AchievementStickerEntity {
        return .init(
            id: self.id,
            image: self.image,
            position: self.position.toDomain(),
            scale: self.scale
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
