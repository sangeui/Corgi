//
//  GroupSelectViewModel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/09.
//

import Foundation
import Combine

class GroupSelectViewModel {
    @Published public private(set) var groups: [Group] = .empty
    @Published public private(set) var group: Group? = nil
    
    private var immutableGroups: [Group] = .empty {
        didSet { self.groups = self.immutableGroups}
    }
    
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func requestGroups() {
        self.immutableGroups = self.storageManager.readAllGroups()
    }
    
    func select(group index: Int) {
        self.group = self.groups[index]
    }
    
    func search(_ text: String) {
        guard text.isEmpty.isNot else { self.resetGroups(); return }
        self.groups = self.immutableGroups.filter({ $0.name.contains(text)})
    }
}

private extension GroupSelectViewModel {
    func resetGroups() {
        self.groups = self.immutableGroups
    }
}
