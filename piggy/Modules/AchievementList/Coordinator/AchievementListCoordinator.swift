//
//  AchievementListCoordinator.swift
//  piggy
//
//  Created by Dason Tiovino on 20/08/24.
//

import SwiftUI
import Combine

public final class AchievementListCoordinator {
    
    // MARK: - Properties
    private var navigationController: UINavigationController?
    
    init(
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
    }

    // MARK: - Private
    // Create Document Category View Controller
    private func makeAchievementLitViewController() -> AchievementListViewController {
        let repository = makeAchievementListRepository()
        let useCase = makeAchievementListUseCase(
            respository: repository
        )
        let viewModel = makeAchievementListViewModel(
            useCase: useCase
        )
        let viewController = AchievementListViewController.create(
            with: viewModel
        )
        return viewController
    }
    
    // Create View Model
    private func makeAchievementListViewModel(
        useCase: AchievementListUseCase
    ) -> AchievementListViewModel {
        return AchievementListViewModel(
            coordinator: self,
            useCase: useCase
        )
    }
    
    // Create Use Case
    private func makeAchievementListUseCase(
        respository: AchievementListRepository
    ) -> AchievementListUseCase {
        return DefaultAchievementListUseCase(
            repository: respository
        )
    }
    
    // Create Repository
    private func makeAchievementListRepository() -> AchievementListRepository {
        return DefaultAchievementListRepository()
    }
    
    // Starting Coordinator
    func route() {
        let vc = makeAchievementLitViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func create() -> AchievementListViewController {
        let vc = makeAchievementLitViewController()
        return vc
    }
    
    // TODO: - Make this work effectively?
//    func routeTo() {
//        // addNoteWrapper.isPresented = true
//    }
}

struct AchievementListViewControllerRepresentable: UIViewControllerRepresentable {
    
//    @EnvironmentObject private var addNoteWrapper: AddNoteWrapper

    typealias UIViewControllerType = AchievementListViewController
    
    func makeUIViewController(context: Context) -> AchievementListViewController {
        let coordinator = AchievementListCoordinator(navigationController: nil)
        let viewController = coordinator.create()
//        viewController.addNoteWrapper = addNoteWrapper
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AchievementListViewController, context: Context) {}
}
