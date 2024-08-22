//
//  SaveTransactionListRequestDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct SaveTransactionListRequestDTO: Encodable {
    let id: String
    let date: Date
    let category: String
    let amount: Int
    let currentBalance: Double
}
