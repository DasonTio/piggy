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
    let image: Data?
    let category: String
    let isClaimed: Bool
    let isReadyToClaim: Bool
    let allowanceReward: Int?
    
    init(title: String, image: Data? = nil, category: String, isClaimed: Bool = false, isReadyToClaim:Bool = false, allowanceReward: Int? = nil) {
        self.title = title
        self.image = image
        self.category = category
        self.isClaimed = isClaimed
        self.isReadyToClaim = isReadyToClaim
        self.allowanceReward = allowanceReward
    }
}

extension SaveAchievementListRequest {
    func toRequest() -> SaveAchievementListRequestDTO {
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
