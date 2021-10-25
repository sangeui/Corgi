//
//  BookmarkManager.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/04.
//

import Foundation
import CorgiStorage

class StorageManager {
    typealias SaveResult = ((Result<Bookmark, SavingBookmarkError>) -> Void)
    
    private let bookmarkConverter: ConvertingBookmarkProtocol
    private let storageInterface: CoreDataInterface
    
    init(bookmarkRepository: CoreDataInterface,
         bookmarkConverter: ConvertingBookmarkProtocol) {
        self.storageInterface = bookmarkRepository
        self.bookmarkConverter = bookmarkConverter
    }
    
    func createNewBookmark(_ newBookmark: UnfinishedBookmark, completion: SaveResult) {
        guard let bookmark = self.bookmarkConverter.from(newBookmark) else { return }

        if self.storageInterface.createBookmark(bookmark.convert()) {
            completion(.success(bookmark))
        } else {
            completion(.failure(.savingError))
        }
    }
    
    func deleteGroup(group: UUID) -> Bool {
        return self.storageInterface.deleteGroup(group)
    }
    
    func deleteBookmark(given uuid: UUID) -> Bool {
        return self.storageInterface.deleteBookmark(uuid)
    }
    
    func readAllBookmarks() -> Bookmarks {
        return self.storageInterface.readBookmarks(predicate: nil, sort: nil).map({ $0.convert() }).sorted(by: <)
    }
    
    func readAllGroups() -> [Group] {
        return self.storageInterface.readGroups(predicate: nil, sort: nil).map({ $0.convert() })
    }
    
    func readAllBookmarks(of group: UUID) -> Bookmarks {
        return self.storageInterface.readBookmarks(of: group).map({ $0.convert() })
    }
    
    func update(bookmark: Bookmark) {
        let _ = self.storageInterface.updateBookmark(bookmark.convert())
    }
    
    func editGroupName(group: Group) {
        let _ = self.storageInterface.updateGroup(group.convert())
    }
    
    func reset() {
        self.storageInterface.reset()
    }
}

private extension Bookmark {
    func convert() -> BookmarkRM {
        return .init(url: self.url, group: self.group, description: self.explanation, identifier: self.identifier, dateCreated: self.created, isOpened: self.isOpened)
    }
}

extension Bookmark: Comparable {
    public static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.created > rhs.created
    }
}

private extension BookmarkRM {
    func convert() -> Bookmark {
        return .init(url: self.url, group: self.group, explanation: self.description, identifier: self.identifier, created: self.dateCreated, isOpened: self.isOpened)
    }
}

private extension GroupRM {
    func convert() -> Group {
        return .init(identifier: self.identifier, name: self.name, count: self.count)
    }
}

private extension Group {
    func convert() -> GroupRM {
        return .init(identifier: self.identifier, name: self.name, count: self.count)
    }
}
