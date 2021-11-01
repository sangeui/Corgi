//
//  AppearanceAccessInterface.swift
//  Corgi
//
//  Created by 서상의 on 2021/11/02.
//

import Foundation

protocol AppearanceAccessInterface {
    func update(appearance: Int) -> Bool
    func read() -> Int
}

class AppearanceUserDefaults: AppearanceAccessInterface {
    private let userDefaults: UserDefaults = .standard
    private let key = "Appearance"
    
    func update(appearance: Int) -> Bool {
        self.userDefaults.setValue(appearance, forKey: self.key)
        
        return true
    }
    
    func read() -> Int {
        (self.userDefaults.value(forKey: self.key) as? Int) ?? .zero
    }
}
