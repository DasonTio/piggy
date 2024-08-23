//
//  AchievementListEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation


internal struct AchievementListEntity: Equatable{
    let id: String 
    let title: String
    var image: Data?
    var category: String
    var isClaimed: Bool
    var isReadyToClaim: Bool
    var allowanceReward: Int?
}
