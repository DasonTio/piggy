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

struct ContentView: View {
    @StateObject private var addTransactionWrapper = AddTransactionWrapper()
    @StateObject var router = NavigationRouteController()
    
    var body: some View {
        NavigationStack (
            path: $router.navigationStack){
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .achievement:
                            AchievementView()
                        case .transaction:
                            TransactionListViewControllerRepresentable()
                                .edgesIgnoringSafeArea(.all)
                                .sheet(isPresented: $addTransactionWrapper.isPresented, content: {
                                    AddTransactionViewControllerRepresentable()
                                })
                                .environmentObject(addTransactionWrapper)
                        case .parental:
                            PinViewControllerRepresentable()
                                .environmentObject(router)
                        default:
                            EmptyView()
                        }
                    }
            }
            .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
