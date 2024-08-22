//
//  AchievementListRepository.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import SwiftData
import Combine

internal protocol AchievementListRepository{
    func fetch()->AnyPublisher<[AchievementListEntity]?, Error>
    func save(params: SaveAchievementListRequestDTO)->AnyPublisher<Bool, Error>
    func update(params: UpdateAchievementListRequestDTO)->AnyPublisher<Bool, Error>
    func delete(id: String)->AnyPublisher<Bool, Error>
}

internal final class DefaultAchievementListRepository: AchievementListRepository{
    
    private let container: ModelContainer!
    
    init(container: ModelContainer? = SwiftDataContextManager.shared.container) {
        self.container = container ?? SwiftDataContextManager.shared.container
    }
    
    func fetch() -> AnyPublisher<[AchievementListEntity]?, any Error> {
        return Future<[AchievementListEntity]?, Error>{ promise in
            Task{ @MainActor in
                do{
                    let fetchDescriptor = FetchDescriptor<AchievementListLocalEntity>()
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
    
    func save(params: SaveAchievementListRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{ promise in
            Task{ @MainActor in
                do{
                    //MARK: Change the image params
                    let data = AchievementListLocalEntity(
                        id: params.id,
                        title: params.title,
//                        image: "",
                        isClaimed: params.isClaimed,
                        isReadyToClaim: params.isReadyToClaim,
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
    
    func update(params: UpdateAchievementListRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{promise in
            Task{@MainActor in
                do{
                    let id = params.id
                    let fetchDescriptor = FetchDescriptor<AchievementListLocalEntity>(
                        predicate:#Predicate{
                            $0.id == id
                        }
                    )
                    
                    if let data = try self.container?.mainContext.fetch(fetchDescriptor).first{
                        data.title = params.title
                        data.image = params.image
                        data.category = params.category
                        data.isClaimed = params.isClaimed
                        data.isReadyToClaim = params.isReadyToClaim
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
                let fetchDescriptor = FetchDescriptor<AchievementListLocalEntity>(
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
