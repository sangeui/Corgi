//
//  GroupUseCaseInteractor.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation
import CorgiStorage

class GroupUseCaseInteractor {
    weak var outputBoundary: GroupUseCaseOutputBoundary? = nil
    
    private let dataAccessInterface: GroupAccessInterface
    
    init(dataAccessInterface: GroupAccessInterface) {
        self.dataAccessInterface = dataAccessInterface
    }
}

extension GroupUseCaseInteractor: GroupUseCaseInputBoundary {
    func read() {
        let groups = self.dataAccessInterface.read(predicate: nil, sort: nil)
        self.outputBoundary?.send(groups: groups.map({ $0.toUseCaseModel() }))
    }
    
    func update(group: Group) {
        if self.dataAccessInterface.update(group: group.toDataAccessModel()) {
            self.outputBoundary?.message(.success(.update()))
        } else {
            self.outputBoundary?.message(.failure(.update()))
        }
    }
    
    func delete(uuid: UUID) {
        if self.dataAccessInterface.delete(group: uuid) {
            self.outputBoundary?.message(.success(.delete()))
        } else {
            self.outputBoundary?.message(.failure(.delete()))
        }
    }
    
    func clear() {
        if self.dataAccessInterface.clear() {
            self.outputBoundary?.message(.success(.clear()))
        } else {
            self.outputBoundary?.message(.failure(.clear()))
        }
    }
}

private extension GroupRM {
    func toUseCaseModel() -> Group {
        return .init(identifier: self.identifier, name: self.name, count: self.count)
    }
}

private extension Group {
    func toDataAccessModel() -> GroupRM {
        return .init(identifier: self.identifier, name: self.name, count: self.count)
    }
}
