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
    let image: Data?
    let isClaimed: Bool
    let isReadyToClaim: Bool
    let category: String
    let allowanceReward: Int?
    
    init(id: String, title: String, image: Data? = nil, category: String, isClaimed: Bool = false, isReadyToClaim: Bool = false, allowanceReward: Int? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.category = category
        self.isClaimed = isClaimed
        self.isReadyToClaim = isReadyToClaim
        self.allowanceReward = allowanceReward
    }
}

extension UpdateAchievementListRequest {
    func toRequest() -> UpdateAchievementListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            image: self.image,
            category: self.category,
            isClaimed: self.isClaimed,
            isReadyToClaim: self.isReadyToClaim,
            allowanceReward: self.allowanceReward
        )
    }
}
