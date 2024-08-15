//
//  UpdateAchievementListRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct UpdateAchievementListRequest {
    let id: String
    let title: String
    let amount: Int
    let category: String
}

extension UpdateAchievementListRequest {
    func toRequest() -> UpdateAchievementListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            amount: self.amount,
            category: self.category
        )
    }
}
