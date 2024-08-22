//
//  AchievementStickerUseCase.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation
import Combine

internal protocol AchievementStickerUseCase{
    func fetch()->AnyPublisher<[AchievementStickerEntity]?, Error>
    func save(params: SaveAchievementStickerRequest)->AnyPublisher<Bool, Error>
    func update(params: UpdateAchievementStickerRequest)->AnyPublisher<Bool, Error>
    func delete(id: String)->AnyPublisher<Bool, Error>
}

internal final class DefaultAchievementStickerUseCase: AchievementStickerUseCase{

    private let repository: AchievementStickerRepository
    
    init(repository: AchievementStickerRepository) {
        self.repository = repository
    }

    func fetch() -> AnyPublisher<[AchievementStickerEntity]?, any Error> {
        return repository.fetch()
    }
    
    func save(params: SaveAchievementStickerRequest) -> AnyPublisher<Bool, any Error> {
        return repository.save(params: params.toRequest())
    }
    
    func update(params: UpdateAchievementStickerRequest) -> AnyPublisher<Bool, any Error> {
        return repository.update(params: params.toRequest())
    }
    
    func delete(id: String) -> AnyPublisher<Bool, any Error> {
        return repository.delete(id: id)
    }
}
