//
//  SaveTransactionListRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct SaveTransactionListRequest {
    let id: String = UUID().uuidString
    let title: String
    let amount: Int
    let category: String
}

extension SaveTransactionListRequest {
    func toRequest() -> SaveTransactionListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            amount: self.amount,
            category: self.category
        )
    }
}
