//
//  GroupSelectViewModel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/09.
//

import Foundation
import Combine
import CorgiStorage

class GroupSelectViewModel {
    @Published public private(set) var groups: [Group] = .empty
    @Published public private(set) var group: Group? = nil
    
    private var immutableGroups: [Group] = .empty {
        didSet { self.groups = self.immutableGroups}
    }
    
    private let groupUseCaseInteractor: GroupUseCaseInteractor = .init(dataAccessInterface: CoreDataInterface()!)
    
    init() {
        self.groupUseCaseInteractor.outputBoundary = self
    }
    
    func requestGroups() {
        self.groupUseCaseInteractor.read()
    }
    
    func select(group index: Int) {
        self.group = self.groups[index]
    }
    
    func search(_ text: String) {
        guard text.isEmpty.isNot else { self.resetGroups(); return }
        self.groups = self.immutableGroups.filter({ $0.name.contains(text)})
    }
}

extension GroupSelectViewModel: GroupUseCaseOutputBoundary {
    func send(groups: [Group]) {
        self.immutableGroups = groups
    }
}

private extension GroupSelectViewModel {
    func resetGroups() {
        self.groups = self.immutableGroups
    }
}
