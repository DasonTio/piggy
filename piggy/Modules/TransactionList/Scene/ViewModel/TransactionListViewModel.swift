//
//  TransactionListViewModel.swift
//  piggy
//
//  Created by Eric Fernando on 22/08/24.
//

import Foundation
import Combine

internal final class TransactionListViewModel {
    
    // MARK: - Properties
    private let coordinator: TransactionListCoordinator
    private let useCase: TransactionListUseCase
    private var cancellables = Set<AnyCancellable>()
    let output = Output()

    private var item: [TransactionListEntity]?
    
    // MARK: - Input Output Variable
    struct Input {
        let didLoad: PassthroughSubject<Void, Never>
        let didAddNewTransaction: PassthroughSubject<SaveTransactionListRequest, Never> // Pass params
    }
    
    class Output {
        @Published var result: DataState<[TransactionListEntity]> = .initiate
        @Published var addTransaction: DataState<Bool> = .initiate
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Initializer
    init(
        coordinator: TransactionListCoordinator,
        useCase: TransactionListUseCase
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    // MARK: - Functions
    func bind(_ input: Input) {
        output.result = .loading
        input.didLoad
            .receive(on: DispatchQueue.global())
            .flatMap {
                return self.useCase.fetch()
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let model):
                    self.item = model
                    self.output.result = .success(data: model ?? [])
                case .failure(let error):
                    self.output.result = .failed(reason: error)
                }
            }
            .store(in: &cancellables)
        
        // TODO: - Add some POST here
        input.didAddNewTransaction
            .receive(on: DispatchQueue.global())
            .flatMap({ request in
                return self.useCase.save(params: .init(date: request.date, category: request.category, amount: request.amount))
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.output.addTransaction = .success(data: data)
                case .failure(let error):
                    self.output.addTransaction = .failed(reason: error)
                }
            }
            .store(in: &cancellables)
    }
}
