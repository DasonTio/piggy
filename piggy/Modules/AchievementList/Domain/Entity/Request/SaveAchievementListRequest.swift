//
//  SaveAchievementListRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct SaveAchievementListRequest {
    let id: String = UUID().uuidString
    let title: String
    let amount: Int
    let category: String
}

extension SaveAchievementListRequest {
    func toRequest() -> SaveAchievementListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            amount: self.amount,
            category: self.category
        )
    }
}
