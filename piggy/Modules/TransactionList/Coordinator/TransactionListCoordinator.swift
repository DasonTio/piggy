//
//  TransactionListCoordinator.swift
//  piggy
//
//  Created by Eric Fernando on 19/08/24.
//

import SwiftUI
import Combine

public final class TransactionListCoordinator {
    
    // MARK: - Properties
    private var navigationController: UINavigationController?
    
    init(
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
    }

    // MARK: - Private
    // Create Document Category View Controller
    private func makeTransactionListViewController() -> TransactionListViewController {
        let repository = makeTransactionListRepository()
        let useCase = makeTransactionListUseCase(
            respository: repository
        )
        let viewController = TransactionListViewController.create()
        return viewController
    }
    
    // Create Use Case
    private func makeTransactionListUseCase(
        respository: TransactionListRepository
    ) -> TransactionListUseCase {
        return DefaultTransactionListUseCase(
            repository: respository
        )
    }
    
    // Create Repository
    private func makeTransactionListRepository() -> TransactionListRepository {
        return DefaultTransactionListRepository()
    }
    
    // Starting Coordinator
    func route() {
        let vc = makeTransactionListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func create() -> TransactionListViewController {
        let vc = makeTransactionListViewController()
        return vc
    }
    
    // TODO: - Make this work effectively?
    func routeToAddNote() {
        // addNoteWrapper.isPresented = true
    }
}

struct TransactionListViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var addTransactionWrapper: AddTransactionWrapper
    
    typealias UIViewControllerType = TransactionListViewController
    
    func makeUIViewController(context: Context) -> TransactionListViewController {
        let coordinator = TransactionListCoordinator(navigationController: nil)
        let viewController = coordinator.create()
        viewController.addTransactionWrapper = addTransactionWrapper
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: TransactionListViewController, context: Context) {}
}
