//
//  TransactionListViewModel.swift
//  piggy
//
//  Created by Eric Fernando on 22/08/24.
//

import Foundation
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
        let didAddNewTransaction: PassthroughSubject<SaveTransactionListRequest, Never> // Pass title
    }
    
    class Output {
        @Published var result: DataState<[TransactionListEntity]> = .initiate
        @Published var addNote: DataState<Bool> = .initiate
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Initializer
    init(
        coordinator: NoteListCoordinator,
        useCase: NoteListUseCase
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
        
        input.didTapAddReminderButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator.routeToAddNote()
            }
            .store(in: &cancellables)
        
        // TODO: - Add some PUT here
        input.didMarkNote
            .receive(on: DispatchQueue.global())
            .flatMap({ request in
                return self.useCase.update(
                    param: .init(
                        id: request.id,
                        completed: request.isCompleted
                    ))
                .map { Result.success($0) }
                .catch { Just(Result.failure($0)) }
                .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    debugPrint("Success update!")
                case .failure(let error):
                    self.output.result = .failed(reason: error)
                }
            }
            .store(in: &cancellables)
        
        // TODO: - Add some DELETE here
                input.didDeleteNote
                    .receive(on: DispatchQueue.global())
                    .flatMap({ request in
                        return self.useCase.delete(id: request)
                        .map { Result.success($0) }
                        .catch { Just(Result.failure($0)) }
                        .eraseToAnyPublisher()
                    })
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success:
                            debugPrint("Success delete!")
                        case .failure(let error):
                            self.output.result = .failed(reason: error)
                        }
                    }
                    .store(in: &cancellables)
        
        // TODO: - Add some POST here
        input.didAddNewNote
            .receive(on: DispatchQueue.global())
            .flatMap({ request in
                return self.useCase.save(param: .init(id: request.id,title: request.title, todoCount: 0))
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.output.addNote = .success(data: data)
                case .failure(let error):
                    self.output.addNote = .failed(reason: error)
                }
            }
            .store(in: &cancellables)
    }
}
