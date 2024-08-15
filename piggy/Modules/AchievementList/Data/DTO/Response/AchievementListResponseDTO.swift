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
    let amount: Int?
    let category: String?
}

internal extension AchievementListResponseDTO {
    func toDomain() -> AchievementListEntity {
        return .init(
            id: self.id ?? "-",
            title: self.title ?? "-",
            amount: self.amount ?? 0,
            category: self.category ?? "-"
        )
    }
}

