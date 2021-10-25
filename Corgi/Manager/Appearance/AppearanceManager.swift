//
//  AppearanceManager.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/19.
//

import Foundation

class AppearanceManager {
    private let storage: AppearanceStorageProtocol = UserDefaultsAppearanceStorage()
    private let key = "Appearance"
    
    func setAppearance(to appearance: Int) {
        self.storage.set(appearance)
    }
    
    func getAppearance() -> Int? {
        return self.storage.get()
    }
}

protocol AppearanceStorageProtocol {
    typealias Appearance = Int
    
    func set(_ appearance: Appearance)
    func get() -> Appearance?
}

class UserDefaultsAppearanceStorage: AppearanceStorageProtocol {
    private let key: String = "Appearance"
    private let userDefaults: UserDefaults = .standard
    
    func get() -> Appearance? {
        self.userDefaults.value(forKey: self.key) as? Appearance
    }
    
    func set(_ appearance: Appearance) {
        self.userDefaults.setValue(appearance, forKey: self.key)
    }
}
