//
//  Bookmark Access Interface.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/31.
//

import Foundation
import CorgiStorage

protocol BookmarkAccessInterface {
    func create(_ bookmark: BookmarkRM) -> Bool
    func read(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [BookmarkRM]
    func read(group: UUID) -> [BookmarkRM]
    func update(bookmark: BookmarkRM) -> Bool
    func delete(uuid: UUID) -> Bool
}

extension CoreDataInterface: BookmarkAccessInterface {
    func create(_ bookmark: BookmarkRM) -> Bool {
        return self.createBookmark(bookmark)
    }
    
    func read(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [BookmarkRM] {
        return self.readBookmarks(predicate: predicate, sort: sort)
    }
    
    func read(group: UUID) -> [BookmarkRM] {
        return self.readBookmarks(of: group)
    }
    
    func update(bookmark: BookmarkRM) -> Bool {
        return self.updateBookmark(bookmark)
    }
    
    func delete(uuid: UUID) -> Bool {
        return self.deleteBookmark(uuid)
    }
}
