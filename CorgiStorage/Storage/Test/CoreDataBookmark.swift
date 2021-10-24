//
//  CoreDataBookmark.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/11.
//

import CoreData

class CoreDataBookmark {
    private let context: NSManagedObjectContext
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Create
    
    func create(_ bookmark: BookmarkRM) -> Bool {
        let bookmarkCDM = bookmark.convert(given: self.context)
        let group: GroupCDM
        let request = NSFetchRequest.groupCDM
        request.predicate = .init(format: "%K == %@", #keyPath(GroupCDM.name), bookmark.group ?? "")
        
        if let result = try? self.context.fetch(request),
           let matchedGroup = result.first {
            group = matchedGroup
        } else {
            let newGroup: GroupCDM = .init(context: self.context)
            newGroup.name = bookmark.group ?? ""
            newGroup.identifier = .init()
            
            group = newGroup
        }
        
        bookmarkCDM.group = group
        
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Read
    
    func readAll(predicate: NSPredicate? = nil, sort: NSSortDescriptor? = nil) -> BookmarkRMs {
        let request = NSFetchRequest.bookmarkCDM
        
        if let sort = sort {
            request.sortDescriptors = [sort]
        }
        
        request.predicate = predicate
        
        if let result = try? self.context.fetch(request) {
            let bookmarks: BookmarkRMs = result.compactMap({ $0.convert() })
            return bookmarks
        }
        
        return .init()
    }
    
    // MARK: - Update
    
    func update(_ bookmark: BookmarkRM) -> Bool {
        let request = NSFetchRequest.bookmarkCDM
        request.predicate = .matched(source: #keyPath(BookmarkCDM.identifier), with: bookmark.identifier as CVarArg)
        
        if let result = try? self.context.fetch(request),
           let matchedBookmark = result.first {
            matchedBookmark.address = bookmark.url
            matchedBookmark.explanation = bookmark.description
            matchedBookmark.isOpened = bookmark.isOpened
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Delete
    
    func delete(_ identifier: UUID) -> Bool {
        let request = NSFetchRequest.bookmarkCDM
        request.predicate = .matched(source: #keyPath(BookmarkCDM.identifier), with: identifier as CVarArg)
        
        if let result = try? self.context.fetch(request),
           let matchedBookmark = result.first {
            self.context.delete(matchedBookmark)
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

private extension CoreDataBookmark {
    
}

private extension BookmarkRM {
    func convert(given context: NSManagedObjectContext) -> BookmarkCDM {
        let link = BookmarkCDM(context: context)
        link.address = self.url
        link.explanation = self.description
        link.create = .init()
        link.identifier = .init()
        link.isOpened = self.isOpened
        
        return link
    }
}

private extension BookmarkCDM {
    func convert() -> BookmarkRM? {
        guard let url = self.address,
              let dateCreated = self.create,
              let identifier = self.identifier else { return nil }
        
        return .init(url: url, group: group?.name, description: self.explanation, identifier: identifier, dateCreated: dateCreated, isOpened: self.isOpened)
    }
}
