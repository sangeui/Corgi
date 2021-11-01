//
//  BookmarkListViewModel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/04.
//

import Foundation
import Combine
import CorgiStorage

class BookmarksViewModel {
    @Published public private(set) var bookmarks: Bookmarks = []
    @Published public private(set) var group: Group
    
    private let bookmarkNavigator: BookmarkNavigator
    
    private let bookmarkUseCaseInteractor: BookmarkUseCaseInteractor = .init(dataAccessInterface: CoreDataInterface()!)
    
    init(bookmarkNavigator: BookmarkNavigator,
         category: Group) {
        self.bookmarkNavigator = bookmarkNavigator
        self.group = category
        
        self.bookmarkUseCaseInteractor.outputBoundary = self
    }
    
    func requestBookmarkList() {
        self.bookmarkUseCaseInteractor.read()
    }
    
    func change(to group: Group) {
        self.group = group
    }
    
    func navigate(to bookmark: Int) {
        var bookmark = self.bookmarks[bookmark]
        bookmark.isOpened = .yes
        self.bookmarkUseCaseInteractor.update(bookmark: bookmark)
        self.bookmarkNavigator.navigateToBookmark(bookmark: bookmark)
    }
    
    func faviconImageURL(of index: Int) -> URL? {
        let url = self.bookmarks[index].url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: .no)
        
        let faviconURLstring = "https://\(components?.host ?? "")/favicon.ico"
        return URL(string: faviconURLstring)
    }
    
    @objc func removeBookmark(given row: Int) {
        let bookmark = self.bookmarks[row]
        let identifier = bookmark.identifier
        
        self.bookmarkUseCaseInteractor.delete(identifier)
    }
}

extension BookmarksViewModel: BookmarkUseCaseOutputBoundary {
    func send(bookmarks: [Bookmark]) {
        self.bookmarks = bookmarks
    }
    
    func message(_ message: BookmarkUseCaseMessage) {
        switch message {
        case .success(let bookmarkUseCase):
            switch bookmarkUseCase {
            case .delete(_): self.bookmarkUseCaseInteractor.read()
            default: break
            }
        default: break
        }
    }
}
