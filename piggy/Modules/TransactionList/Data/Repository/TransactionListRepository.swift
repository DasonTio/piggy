//
//  TransactionListRepository.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import SwiftData
import Combine

internal protocol TransactionListRepository{
    func fetch()->AnyPublisher<[TransactionListEntity]?, Error>
    func save(params: SaveTransactionListRequestDTO)->AnyPublisher<Bool, Error>
    func update(params: UpdateTransactionListRequestDTO)->AnyPublisher<Bool, Error>
    func delete(id: String)->AnyPublisher<Bool, Error>
}

internal final class DefaultTransactionListRepository: TransactionListRepository{
    
    private let container: ModelContainer!
    
    init(container: ModelContainer? = SwiftDataContextManager.shared.container) {
        self.container = container ?? SwiftDataContextManager.shared.container
    }
    
    func fetch() -> AnyPublisher<[TransactionListEntity]?, any Error> {
        return Future<[TransactionListEntity]?, Error>{ promise in
            Task{ @MainActor in
                do{
                    let fetchDescriptor = FetchDescriptor<TransactionListLocalEntity>()
                    let data = try self.container?.mainContext.fetch(fetchDescriptor)
                    let result = data?.compactMap{$0.toDomain()}
                    
                    promise(.success(result))
                }catch{
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(params: SaveTransactionListRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{ promise in
            Task{ @MainActor in
                do{
                    let data = TransactionListLocalEntity(
                        id: params.id,
                        title: params.title,
                        amount: params.amount,
                        category: params.category
                    )
                    
                    self.container?.mainContext.insert(data)
                    try self.container?.mainContext.save()
                    
                    promise(.success(true))
                }catch{
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func update(params: UpdateTransactionListRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{promise in
            Task{@MainActor in
                do{
                    
                    let id = params.id
                    let fetchDescriptor = FetchDescriptor<TransactionListLocalEntity>(
                        predicate: #Predicate {
                            $0.id == id
                        }
                    )
                    
                    if let data = try self.container?.mainContext.fetch(fetchDescriptor).first{
                        data.title = params.title
                        data.amount = params.amount
                        data.category = params.category
                        try self.container?.mainContext.save()
                        promise(.success(true))
                    }else{
                        throw NetworkError.noData
                    }
                }catch{
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{ promise in
            Task{ @MainActor in
                let fetchDescriptor = FetchDescriptor<TransactionListLocalEntity>(
                    predicate: #Predicate{
                        $0.id == id
                    }
                )
           
                do{
                    if let data = try self.container?.mainContext.fetch(fetchDescriptor).first {
                        self.container?.mainContext.delete(data)
                        try self.container?.mainContext.save()
                        promise(.success(true))
                    }else{
                        throw NetworkError.noData
                    }
                }catch{
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
