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
    
    var body: some View {
        NavigationStack {
            HomeView()
//            TransactionListViewControllerRepresentable()
//                .edgesIgnoringSafeArea(.all)
//                .sheet(isPresented: $addTransactionWrapper.isPresented, content: {
//                    AddTransactionViewControllerRepresentable()
//                })
//            
//            AchievementView()
        }
        .environmentObject(addTransactionWrapper)
    }
}

#Preview {
    ContentView()
}
