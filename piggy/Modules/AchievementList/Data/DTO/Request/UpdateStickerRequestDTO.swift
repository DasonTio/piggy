//
//  UpdateStickerRequestDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

internal struct UpdateAchievementStickerRequestDTO: Encodable {
    let id: String
    let image: String
    let position: StickerPositionDTO
    let scale: Float?
    let isShowed: Bool
}
