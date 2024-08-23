//
//  ContentView.swift
//  piggy
//
//  Created by Dason Tiovino on 13/08/24.
//

import SwiftUI

class AddTransactionWrapper: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var category: String?
    @Published var amount: Int?
}

class AddAchievementWrapper: ObservableObject {
    @Published var isPresented: Bool = false
}

struct ContentView: View {
    @StateObject private var addTransactionWrapper = AddTransactionWrapper()
    @StateObject private var addAchievementWrapper = AddAchievementWrapper()
    @StateObject var router = NavigationRouteController()
    
    var body: some View {
        NavigationStack (
            path: $router.navigationStack){
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .achievement:
                            AchievementView()
                                .environmentObject(router)
                        case .transaction:
                            TransactionListViewControllerRepresentable()
                                .edgesIgnoringSafeArea(.all)
                                .sheet(isPresented: $addTransactionWrapper.isPresented, content: {
                                    AddTransactionViewControllerRepresentable()
                                })
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(router)
                                .environmentObject(addTransactionWrapper)
                        case .pin:
                            PinViewControllerRepresentable()
                                .ignoresSafeArea()
                                .navigationBarBackButtonHidden()
                                .environmentObject(router)
                        case .parentalSetting:
                            ParentalSettingViewControllerRepresentable()
                                .ignoresSafeArea()
                                .customSheet(isPresented: $addAchievementWrapper.isPresented, content: {
                                    AddAchievementView()
                                })
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(addAchievementWrapper)
                                .environmentObject(router)
                        }
                    }
            }
            .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
