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
    
    private let dataAccessInterface: BookmarkAccessInterface
    private let validator: ValidationRule = .init()
    
    init(dataAccessInterface: BookmarkAccessInterface) {
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
        let bookmarks = self.sort(bookmarks: self.dataAccessInterface.read(predicate: nil, sort: nil))
        self.outputBoundary?.send(bookmarks: bookmarks)
    }
    
    func read(group: UUID) {
        let bookmarks = self.sort(bookmarks: self.dataAccessInterface.read(group: group))
        self.outputBoundary?.send(bookmarks: bookmarks)
    }
    
    func update(bookmark: Bookmark) {
        if self.dataAccessInterface.update(bookmark: bookmark.toDataAccessModel()) {
            self.outputBoundary?.message(.success(.update()))
        } else {
            self.outputBoundary?.message(.failure(.update()))
        }
    }
    
    func delete(_ uuid: UUID) {
        if self.dataAccessInterface.delete(uuid: uuid) {
            self.outputBoundary?.message(.success(.delete()))
        } else {
            self.outputBoundary?.message(.failure(.delete()))
        }
    }
}

private extension BookmarkUseCaseInteractor {
    func send(bookmark: Bookmark) -> Bool {
        return self.dataAccessInterface.create(bookmark.toDataAccessModel())
    }
    
    func sort(bookmarks: [BookmarkRM]) -> [Bookmark] {
        return bookmarks.map({ $0.toUseCaseModel() }).sorted(by: <)
    }
}

private extension BookmarkUseCaseInteractor {
    func prepare(url: URL, comment: String, group: String) -> Bookmark {
        return .init(url: url, group: group, comment: comment, identifier: .init(), created: .init(), isOpened: false)
    }
}

private extension Bookmark {
    func toDataAccessModel() -> BookmarkRM {
        return .init(url: self.url, group: self.group, description: self.comment, identifier: self.identifier, dateCreated: self.created, isOpened: self.isOpened)
    }
}

private extension BookmarkRM {
    func toUseCaseModel() -> Bookmark {
        return .init(url: self.url, group: self.group, comment: self.description, identifier: self.identifier, created: self.dateCreated, isOpened: self.isOpened)
    }
}
