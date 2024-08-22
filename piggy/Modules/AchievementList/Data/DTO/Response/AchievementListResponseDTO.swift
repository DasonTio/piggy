//
//  AchievementListResponseDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct AchievementListResponseDTO: Codable {
    let id: String?
    let title: String?
    let image: Data?
    let category: String?
    let isClaimed: Bool?
    let isReadyToClaim: Bool?
}

internal extension AchievementListResponseDTO {
    func toDomain() -> AchievementListEntity {
        return .init(
            id: self.id ?? "-",
            title: self.title ?? "-",
            image: self.image,
            category: self.category ?? "-",
            isClaimed: self.isClaimed ?? false,
            isReadyToClaim: self.isReadyToClaim ?? false
        )
    }
}

