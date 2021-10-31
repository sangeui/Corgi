//
//  GroupAccessInterface.swift
//  Corgi
//
//  Created by 서상의 on 2021/11/01.
//

import Foundation
import CorgiStorage

protocol GroupAccessInterface {
    func read(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [GroupRM]
    func update(group: GroupRM) -> Bool
    func delete(group: UUID) -> Bool
    func clear() -> Bool
}

extension CoreDataInterface: GroupAccessInterface {
    func read(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [GroupRM] {
        return self.readGroups(predicate: predicate, sort: sort)
    }
    
    func update(group: GroupRM) -> Bool {
        return self.updateGroup(group)
    }
    
    func delete(group: UUID) -> Bool {
        return self.deleteGroup(group)
    }
    
    func clear() -> Bool {
        return self.reset()
    }
}


