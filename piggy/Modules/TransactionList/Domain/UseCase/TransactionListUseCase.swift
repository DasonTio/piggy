//
//  TransactionListUseCase.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import Combine

internal protocol TransactionListUseCase{
    func fetch()->AnyPublisher<[TransactionListEntity]?, Error>
    func save(params: SaveTransactionListRequest)->AnyPublisher<Bool, Error>
}

internal final class DefaultTransactionListUseCase: TransactionListUseCase{
    private let repository: TransactionListRepository
    
    init(repository: TransactionListRepository) {
        self.repository = DefaultTransactionListRepository()
    }

    func fetch() -> AnyPublisher<[TransactionListEntity]?, any Error> {
        return repository.fetch()
    }
    
    func save(params: SaveTransactionListRequest) -> AnyPublisher<Bool, any Error> {
        return repository.save(params: params.toRequest())
    }
}
