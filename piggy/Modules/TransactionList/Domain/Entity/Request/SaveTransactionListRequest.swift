//
//  SaveTransactionListRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct SaveTransactionListRequest {
    let id: String = UUID().uuidString
    let date: Date
    let category: String
    let amount: Int
}

extension SaveTransactionListRequest {
    func toRequest() -> SaveTransactionListRequestDTO {
        return .init(
            id: self.id,
            date: self.date,
            category: self.category,
            amount: self.amount
        )
    }
}
