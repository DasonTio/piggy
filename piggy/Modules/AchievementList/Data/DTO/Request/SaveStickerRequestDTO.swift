//
//  SaveStickerRequestDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

internal struct StickerPositionDTO: Codable {
    let x: Float
    let y: Float
}
extension StickerPositionDTO{
    func toDomain() -> StickerPosition{
        return .init(
            x: self.x,
            y: self.y
        )
    }
    func toLocal() -> StickerPositionLocalEntity{
        return .init(
            x: self.x,
            y: self.y
        )
    }
}


internal struct SaveAchievementStickerRequestDTO: Encodable {
    let id: String
    let image: String
    let position: StickerPositionDTO
    let scale: Float?
    let isShowed: Bool
}


