//
//  CoreDataGroup.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/11.
//

import CoreData

class CoreDataGroup {
    private let context: NSManagedObjectContext
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Create
    
    // MARK: Read
    
    func readAll(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [GroupRM] {
        let request = NSFetchRequest.groupCDM
        
        if let sort = sort {
            request.sortDescriptors = [sort]
        }
        
        request.predicate = predicate
        
        if let result = try? self.context.fetch(request) {
            let groups: [GroupRM] = result.compactMap({ $0.convert() })
            return groups
        }
        
        return .init()
    }
    
    // MARK: Update
    
    func update(_ group: GroupRM) -> Bool {
        let request = NSFetchRequest.groupCDM
        request.predicate = .matched(source: #keyPath(BookmarkCDM.identifier), with: group.identifier as CVarArg)
        
        if let result = try? self.context.fetch(request),
           let matchedGroup = result.first {
            matchedGroup.name = group.name
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: Delete
    
    func delete(_ identifier: UUID) -> Bool {
        let request = NSFetchRequest.groupCDM
        request.predicate = .matched(source: #keyPath(GroupCDM.identifier), with: identifier as CVarArg)
        
        if let result = try? self.context.fetch(request),
           let matchedGroup = result.first {
            self.context.delete(matchedGroup)
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            self.context.rollback()
            return false
        }
    }
}

private extension GroupCDM {
    func convert() -> GroupRM? {
        guard let name = self.name,
              let count = self.list?.count,
              let identifier = self.identifier else { return nil }
        
        return .init(identifier: identifier, name: name, count: count)
    }
}
