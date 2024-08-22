//
//  piggyApp.swift
//  piggy
//
//  Created by Dason Tiovino on 13/08/24.
//

import SwiftUI

@main

struct piggyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                AchievementView()
//                AchievementListViewControllerRepresentable()
            }
        }
    }
}
