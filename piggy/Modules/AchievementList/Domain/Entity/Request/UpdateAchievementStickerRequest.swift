//
//  UpdateAchievementStickerRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

internal struct UpdateAchievementStickerRequest {
    let id: String
    let image: String
    let position: StickerPosition
    let scale: Float?
    let isShowed: Bool
}


extension UpdateAchievementStickerRequest {
    func toRequest() -> UpdateAchievementStickerRequestDTO {
        return .init(
            id: self.id,
            image: self.image,
            position: StickerPositionDTO(
                x: self.position.x,
                y: self.position.y
            ),
            scale: self.scale,
            isShowed: self.isShowed
        )
    }
}
