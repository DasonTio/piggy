//
//  SaveTransactionListResponseDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct TransactionListResponseDTO: Codable {
    let id: String?
    let title: String?
    let amount: Int?
    let category: String?
}

internal extension TransactionListResponseDTO {
    func toDomain() -> TransactionListEntity {
        return .init(
            id: self.id ?? "-",
            title: self.title ?? "-",
            amount: self.amount ?? 0,
            category: self.category ?? "-"
        )
    }
}

