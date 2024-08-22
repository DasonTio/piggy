//
//  SaveAchievementStickerRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

internal struct SaveAchievementStickerRequest {
    let id: String = UUID().uuidString
    let image: String
    let position: StickerPosition
    let scale: Float?
    let isShowed: Bool
}


extension SaveAchievementStickerRequest {
    func toRequest() -> SaveAchievementStickerRequestDTO {
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


