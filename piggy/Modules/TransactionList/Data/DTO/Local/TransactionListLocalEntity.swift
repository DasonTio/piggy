//
//  TransactionListEntityDTO.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import SwiftData

@Model
class TransactionListLocalEntity{
    @Attribute(.unique) var id: String
    var date: Date
    var category: String
    var amount: Int
    var currentBalance: Double
 
    
    init(id: String, date: Date, category: String, amount: Int, currentBalance: Double) {
        self.id = id
        self.date = date
        self.category = category
        self.amount = amount
        self.currentBalance = currentBalance
    }
}

extension TransactionListLocalEntity{
    func toDomain() -> TransactionListEntity {
        return .init(
            id: self.id,
            date: self.date,
            category: self.category,
            amount: self.amount,
            currentBalance: self.currentBalance
        )
    }
}
