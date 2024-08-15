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
    var title: String
    var amount: Int
    var category: String
 
    
    init(id: String, title: String, amount: Int, category: String) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
    }
}

extension TransactionListLocalEntity{
    func toDomain() -> TransactionListEntity {
        return .init(
            id: self.id,
            title: self.title,
            amount: self.amount,
            category: self.category
        )
    }
}
