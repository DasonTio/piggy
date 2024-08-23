//
//  UserDefaultManager.swift
//  piggy
//
//  Created by Dason Tiovino on 22/08/24.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let pin = "UserPIN"
        static let balance = "UserBalance"
    }
    
    private init() {}
    
    // MARK: - PIN
    
    func savePIN(_ pin: String) {
        userDefaults.set(pin, forKey: Keys.pin)
        NotificationCenter.default.post(name: .pinDidChange, object: nil)
    }
    
    func getPIN() -> String? {
        return userDefaults.string(forKey: Keys.pin)
    }
    
    // MARK: - Balance
    
    func saveBalance(_ balance: Double) {
        userDefaults.set(balance, forKey: Keys.balance)
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }
    
    func getBalance() -> Double {
        return userDefaults.double(forKey: Keys.balance)
    }
}

extension Notification.Name {
    static let pinDidChange = Notification.Name("pinDidChange")
    static let balanceDidChange = Notification.Name("balanceDidChange")
}
