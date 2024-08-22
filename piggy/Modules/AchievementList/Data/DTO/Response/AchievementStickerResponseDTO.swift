//
//  AchievementStickerResponseDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

internal struct AchievementStickerResponseDTO: Codable {
    let id: String?
    var image: String?
    var position: StickerPositionDTO?
    var scale: Float?
}

internal extension AchievementStickerResponseDTO {
    func toDomain() -> AchievementStickerEntity {
        return .init(
            id: self.id ?? "-",
            image: self.image ?? "-",
            position: self.position?.toDomain() ?? StickerPosition(x: 0, y: 0),
            scale: self.scale ?? 0.0
        )
    }
}

