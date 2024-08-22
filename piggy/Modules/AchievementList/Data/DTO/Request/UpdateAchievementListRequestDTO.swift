//
//  UpdateAchievementListRequestDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct UpdateAchievementListRequestDTO: Encodable {
    let id: String
    let title: String
    let image: Data?
    let category: String
    let isClaimed: Bool
    let isReadyToClaim: Bool
}
