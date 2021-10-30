//
//  BookmarkUseCaseInteractor.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation
import CorgiStorage

class BookmarkUseCaseInteractor {
    weak var outputBoundary: BookmarkUseCaseOutputBoundary? = nil
    
    private let dataAccessInterface: CoreDataInterface
    private let validator: ValidationRule = .init()
    
    init(dataAccessInterface: CoreDataInterface) {
        self.dataAccessInterface = dataAccessInterface
    }
}

extension BookmarkUseCaseInteractor: BookmarkUseCaseInputBoundary {
    func create(url: String, comment: String, group: String) {
        guard case .success(url: let url) = self.validator.validate(url: url) else {
            self.outputBoundary?.message(.failure(.create())); return
        }
        
        let bookmark = self.prepare(url: url, comment: comment, group: group)
        
        if self.send(bookmark: bookmark) {
            self.outputBoundary?.message(.success(.create()))
        } else {
            self.outputBoundary?.message(.failure(.create()))
        }
    }
    
    func read() {
        let bookmarks = self.sort(bookmarks: self.dataAccessInterface.readBookmarks(predicate: nil, sort: nil))
        self.outputBoundary?.send(bookmarks: bookmarks)
    }
    
    func read(group: UUID) {
        let bookmarks = self.sort(bookmarks: self.dataAccessInterface.readBookmarks(predicate: nil, sort: nil))
        self.outputBoundary?.send(bookmarks: bookmarks)
    }
    
    func update(bookmark: Bookmark) {
        if self.dataAccessInterface.updateBookmark(bookmark.toDataAccessModel()) {
            self.outputBoundary?.message(.success(.update()))
        } else {
            self.outputBoundary?.message(.failure(.update()))
        }
    }
    
    func delete(_ uuid: UUID) {
        if self.dataAccessInterface.deleteBookmark(uuid) {
            self.outputBoundary?.message(.success(.delete()))
        } else {
            self.outputBoundary?.message(.failure(.delete()))
        }
    }
}

private extension BookmarkUseCaseInteractor {
    func send(bookmark: Bookmark) -> Bool {
        return self.dataAccessInterface.createBookmark(bookmark.toDataAccessModel())
    }
    
    func sort(bookmarks: [BookmarkRM]) -> [Bookmark] {
        return bookmarks.map({ $0.toUseCaseModel() }).sorted(by: <)
    }
}

private extension BookmarkUseCaseInteractor {
    func prepare(url: URL, comment: String, group: String) -> Bookmark {
        return .init(url: url, group: group, explanation: comment, identifier: .init(), created: .init(), isOpened: false)
    }
}

private extension Bookmark {
    func toDataAccessModel() -> BookmarkRM {
        return .init(url: self.url, group: self.group, description: self.explanation, identifier: self.identifier, dateCreated: self.created, isOpened: self.isOpened)
    }
}

private extension BookmarkRM {
    func toUseCaseModel() -> Bookmark {
        return .init(url: self.url, group: self.group, explanation: self.description, identifier: self.identifier, created: self.dateCreated, isOpened: self.isOpened)
    }
}
