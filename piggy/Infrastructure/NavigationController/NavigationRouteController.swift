//
//  NavigationRouteController.swift
//  piggy
//
//  Created by Dason Tiovino on 23/08/24.
//

import Foundation
import SwiftUI
import Combine

enum Route: Hashable {
    case achievement
    case transaction
    case pin
    case parentalSetting
}

class NavigationRouteController: ObservableObject {
    @Published var navigationStack: [Route] = []
    
    func push(_ route: Route) {
        navigationStack.append(route)
    }
    
    func pop() {
        navigationStack.popLast()
    }
    
    func popToRoot() {
        navigationStack.removeAll()
    }
}
