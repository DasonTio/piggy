//
//  AchievementStickerRepository.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation
import Combine
import SwiftData

internal protocol AchievementStickerRepository{
    func fetch()->AnyPublisher<[AchievementStickerEntity]?, Error>
    func save(params: SaveAchievementStickerRequestDTO)->AnyPublisher<Bool, Error>
    func update(params: UpdateAchievementStickerRequestDTO)->AnyPublisher<Bool, Error>
    func delete(id: String)->AnyPublisher<Bool, Error>
}



internal final class DefaultAchievementStickerRepository: AchievementStickerRepository{
    
    
    
    private let container: ModelContainer!
    
    init(container: ModelContainer? = SwiftDataContextManager.shared.container) {
        self.container = container ?? SwiftDataContextManager.shared.container
    }
    
    func fetch() -> AnyPublisher<[AchievementStickerEntity]?, any Error> {
        return Future<[AchievementStickerEntity]?, Error>{ promise in
            Task{ @MainActor in
                do{
                    let fetchDescriptor = FetchDescriptor<AchievementStickerLocalEntity>()
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
    
    func save(params: SaveAchievementStickerRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{ promise in
            Task{ @MainActor in
                do{
                    //MARK: Change the image params
                    let data = AchievementStickerLocalEntity(
                        id: params.id,
                        image: params.image, 
                        position: params.position.toLocal(),
                        scale: params.scale,
                        isShowed: params.isShowed
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
    
    func update(params: UpdateAchievementStickerRequestDTO) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error>{promise in
            Task{@MainActor in
                do{
                    let id = params.id
                    let fetchDescriptor = FetchDescriptor<AchievementStickerLocalEntity>(
                        predicate:#Predicate{
                            $0.id == id
                        }
                    )
                    
                    if let data = try self.container?.mainContext.fetch(fetchDescriptor).first{
                        data.image = params.image
                        data.position = params.position.toLocal()
                        data.scale = params.scale
                        data.isShowed = params.isShowed
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
                let fetchDescriptor = FetchDescriptor<AchievementStickerLocalEntity>(
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
