//
//  UpdateTransactionListRequest.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct UpdateTransactionListRequest {
    let id: String
    let title: String
    let amount: Int
    let category: String
}

extension UpdateTransactionListRequest {
    func toRequest() -> UpdateTransactionListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            amount: self.amount,
            category: self.category
        )
    }
}
