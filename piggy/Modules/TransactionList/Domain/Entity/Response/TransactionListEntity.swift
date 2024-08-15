//
//  TransactionListEntity.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation


internal struct TransactionListEntity: Equatable{
    let id: String 
    let title: String
    var amount: Int
    var category: String
}
