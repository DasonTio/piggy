//
//  SwiftDataContextManager.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation
import SwiftData

public class SwiftDataContextManager {
    public static var shared = SwiftDataContextManager()
    var container: ModelContainer?
    var context: ModelContext?

    init() {
        do {
            container = try ModelContainer(for:TransactionListLocalEntity.self, AchievementListLocalEntity.self, StickerPositionLocalEntity.self, AchievementStickerLocalEntity.self )
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}

