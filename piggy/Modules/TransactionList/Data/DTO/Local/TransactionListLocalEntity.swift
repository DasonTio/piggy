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
 
    
    init(id: String, date: Date, category: String, amount: Int) {
        self.id = id
        self.date = date
        self.category = category
        self.amount = amount
    }
}

extension TransactionListLocalEntity{
    func toDomain() -> TransactionListEntity {
        return .init(
            id: self.id,
            date: self.date,
            category: self.category,
            amount: self.amount
            
        )
    }
}
