//
//  TransactionListEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct TransactionListEntity: Equatable{
    let id: String
    let date: Date
    let category: String
    let amount: Int
}
