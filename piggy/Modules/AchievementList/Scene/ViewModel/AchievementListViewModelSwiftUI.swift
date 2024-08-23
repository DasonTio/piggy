//
//  AchievementListViewModelSwiftUI.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation
import Combine

internal final class AchievementListViewModelSwiftUI: ObservableObject {
    private var achievementUseCase: AchievementListUseCase
    private var stickerUseCase: AchievementStickerUseCase
    private var transactionUseCase: TransactionListUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var data: [AchievementListEntity] = []
    @Published var sticker: [AchievementStickerEntity] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    init(achievementUseCase: AchievementListUseCase, stickerUseCase: AchievementStickerUseCase, transactionUseCase: TransactionListUseCase) {
        self.achievementUseCase = achievementUseCase
        self.stickerUseCase = stickerUseCase
        self.transactionUseCase = transactionUseCase
    }
    
    func fetch() {
        achievementUseCase.fetch()
              .receive(on: DispatchQueue.main)
              .sink(receiveCompletion: { [weak self] completion in
                  guard self != nil else {
                      return 
                  }
                  switch completion {
                  case .finished:
                      break
                  case .failure(_):
                      break
                  }
              }, receiveValue: { [weak self] result in
                  print(result)
                  self?.data = result ?? []
              })
              .store(in: &cancellables)
        
        stickerUseCase.fetch()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard self != nil else{
                    return
                }
                //TODO: Add Completion
                switch completion {
                case .finished:
                    break;
                case .failure:
                    break;
                }
            }, receiveValue: { [weak self] result in
                self?.sticker = result ?? []
            })
            .store(in: &cancellables)
    }
    
    func addAchievementWithAmount(title: String, amount: Int) {
        self.achievementUseCase.save(params: .init(
                title: title,
                category: "",
                allowanceReward: amount
            )
        )
    }
    
    func updateItem(params: UpdateAchievementListRequest){
//        self.useCase.update(params: Update)
    }
    
    func updateItemReadyToClaim(model: AchievementListEntity){
        self.achievementUseCase.update(params: .init(
            id: model.id,
            title: model.title,
            image: model.image,
            category: model.category,
            isClaimed: model.isClaimed,
            isReadyToClaim: !model.isReadyToClaim,
            allowanceReward: model.allowanceReward
            )
        )
        self.fetch()
    }
    
    func updateItemClaimed(model: AchievementListEntity){
        if model.isClaimed{
            showAlert.toggle()
            alertMessage = "The reward already claimed"
            return
        }
        
        if model.isReadyToClaim && !model.isClaimed {
            self.achievementUseCase.update(params: .init(
                id: model.id,
                title: model.title,
                image: model.image,
                category: model.category,
                isClaimed: !model.isClaimed,
                isReadyToClaim: model.isReadyToClaim,
                allowanceReward: model.allowanceReward
                )
            )
            self.stickerUseCase.save(params: .init(
                image: ["Mascot", "Gift"].randomElement() ?? "Mascot",
                position: StickerPosition(x: 0, y: 0),
                scale: 1,
                isShowed: false)
            )
            
            if let allowance = model.allowanceReward {
                print(allowance)
                let currentBalance = UserDefaultsManager.shared.getBalance()
                UserDefaultsManager.shared.saveBalance(currentBalance + Double(allowance))
                self.transactionUseCase.save(params: .init(
                    date: Date(),
                    category: "UangJajan",
                    amount: allowance,
                    currentBalance: UserDefaultsManager.shared.getBalance())
                )
                
            }
        }else{
            showAlert.toggle()
            alertMessage = "The reward cannot be claimed yet"
        }

        self.fetch()
    }
    
    func addSticker(params: SaveAchievementStickerRequest){
        self.stickerUseCase.save(params: params)
        self.fetch()
    }
    
    func updateStickerShowState(model: AchievementStickerEntity){
        self.stickerUseCase.update(params: .init(
            id: model.id,
            image: model.image,
            position: model.position,
            scale: model.scale,
            isShowed: !model.isShowed)
        )
        self.fetch()
    }
    
    func deleteItem(id:String){
        
    }
}

