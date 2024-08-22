//
//  AchievementListViewModel.swift
//  piggy
//
//  Created by Dason Tiovino on 20/08/24.
//

import Foundation
import Combine

internal final class AchievementListViewModel {
    
    // MARK: - Properties
    private let coordinator: AchievementListCoordinator
    private let useCase: AchievementListUseCase
    private var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    private var item: [AchievementListEntity]?
    
    struct Input{
        let didLoad: PassthroughSubject<Void, Never>
        let didTapRewardButton: PassthroughSubject<String, Never>
        let didTapAddAchievementList: PassthroughSubject<Void, Never>
    }
    
    class Output{
        @Published var result: DataState<[AchievementListEntity]> = .initiate
        @Published var addAchievement: DataState<Bool> = .initiate
    }
    
    // MARK: - Initializer
    init(
        coordinator: AchievementListCoordinator = .init(navigationController: nil),
        useCase: AchievementListUseCase
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func bind(_ input: Input){
        output.result = .loading
        input.didLoad
            .receive(on: DispatchQueue.global())
            .flatMap{
                return self.useCase.fetch()
                    .map{Result.success($0)}
                    .catch{Just(Result.failure($0))}
                    .eraseToAnyPublisher()
            }.receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                guard let self else {return}
                
                switch result{
                case.success(let data):
                    self.item = data
                    self.output.result = .success(data: data ?? [])
                case.failure(let error):
                    self.output.result = .failed(reason: error)
                }
            }.store(in: &cancellables)
        
//        input.didTapRewardButton
//            .receive(on: DispatchQueue.global())
//            .flatMap({ request in
//                return self.useCase.update(params: .init(
//                    title: "Hello",
//                    category: "Hello")
//                )
//                .map { Result.success($0) }
//                .catch { Just(Result.failure($0)) }
//                .eraseToAnyPublisher()
//            })
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self else { return }
////                switch result {
////                case .success(let data):
////                    self.output.addNote = .success(data: data)
////                case .failure(let error):
////                    self.output.addNote = .failed(reason: error)
////                }
//            }
//            .store(in: &cancellables)
        
        input.didTapAddAchievementList
            .receive(on: DispatchQueue.global())
            .flatMap({ request in
                return self.useCase.save(params: .init(
                    title: "Hello",
                    category: "Hello")
                )
                .map { Result.success($0) }
                .catch { Just(Result.failure($0)) }
                .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.output.addAchievement = .success(data: data)
                case .failure(let error):
                    self.output.addAchievement = .failed(reason: error)
                }
            }
            .store(in: &cancellables)
        
    }
}
