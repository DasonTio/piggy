//
//  AchievementListUseCase.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import Combine

internal protocol AchievementListUseCase{
    func fetch()->AnyPublisher<[AchievementListEntity]?, Error>
    func save(params: SaveAchievementListRequest)->AnyPublisher<Bool, Error>
    func update(params: UpdateAchievementListRequest)->AnyPublisher<Bool, Error>
    func delete(id: String)->AnyPublisher<Bool, Error>
}

internal final class DefaultAchievementListUseCase: AchievementListUseCase{
    private let repository: AchievementListRepository
    
    init(repository: AchievementListRepository) {
        self.repository = DefaultAchievementListRepository()
    }

    func fetch() -> AnyPublisher<[AchievementListEntity]?, any Error> {
        return repository.fetch()
    }
    
    func save(params: SaveAchievementListRequest) -> AnyPublisher<Bool, any Error> {
        return repository.save(params: params.toRequest())
    }
    
    func update(params: UpdateAchievementListRequest) -> AnyPublisher<Bool, any Error> {
        return repository.update(params: params.toRequest())
    }
    
    func delete(id: String) -> AnyPublisher<Bool, any Error> {
        return repository.delete(id: id)
    }
}
