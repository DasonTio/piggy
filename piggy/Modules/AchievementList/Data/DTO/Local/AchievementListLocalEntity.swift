//
//  AchievementListEntityDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import SwiftData

@Model
internal 
class AchievementListLocalEntity{
    @Attribute(.unique) var id: String
    var title: String
    var category: String
    var isClaimed: Bool
    var isReadyToClaim: Bool
    var allowanceReward: Int?
    @Attribute(.externalStorage) var image: Data?
 
    init(id: String, title: String, image: Data? = nil, isClaimed: Bool = false, isReadyToClaim: Bool = false, category: String, allowanceReward: Int? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.category = category
        self.isClaimed = isClaimed
        self.isReadyToClaim = isReadyToClaim
        self.allowanceReward = allowanceReward
    }
}

extension AchievementListLocalEntity{
    func toDomain() -> AchievementListEntity {
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
