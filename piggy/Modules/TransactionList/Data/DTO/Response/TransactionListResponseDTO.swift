//
//  SaveTransactionListResponseDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

internal struct TransactionListResponseDTO: Codable {
    let id: String?
    let date: Date?
    let category: String?
    let amount: Int?
}

internal extension TransactionListResponseDTO {
    func toDomain() -> TransactionListEntity {
        return .init(
            id: self.id ?? "-",
            date: self.date ?? Date(),
            category: self.category ?? "-",
            amount: self.amount ?? 0
        )
    }
}

