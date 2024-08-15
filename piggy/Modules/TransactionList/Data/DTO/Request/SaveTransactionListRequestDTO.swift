//
//  SaveTransactionListRequestDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct SaveTransactionListRequestDTO: Encodable {
    let id: String
    let title: String
    let amount: Int
    let category: String
}
