//
//  BookmarkListViewModel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/04.
//

import Foundation
import Combine

class BookmarksViewModel {
    @Published public private(set) var bookmarks: Bookmarks = []
    @Published public private(set) var group: Group
    
    private let storageManager: StorageManager
    private let bookmarkNavigator: BookmarkNavigator
    
    init(storageManager: StorageManager,
         bookmarkNavigator: BookmarkNavigator,
         category: Group) {
        self.storageManager = storageManager
        self.bookmarkNavigator = bookmarkNavigator
        self.group = category
    }
    
    func requestBookmarkList() {
        self.bookmarks = self.storageManager.readAllBookmarks(of: self.group.identifier)
    }
    
    func change(to group: Group) {
        self.group = group
    }
    
    func navigate(to bookmark: Int) {
        var bookmark = self.bookmarks[bookmark]
        bookmark.isOpened = .yes
        self.storageManager.update(bookmark: bookmark)
        self.bookmarkNavigator.navigateToBookmark(bookmark: bookmark)
    }
    
    func faviconImageURL(of index: Int) -> URL? {
        let url = self.bookmarks[index].url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: .no)
        
        let faviconURLstring = "https://\(components?.host ?? "")/favicon.ico"
        return URL(string: faviconURLstring)
    }
    
    @objc func removeBookmark(given row: Int) -> Bool {
        let bookmark = self.bookmarks[row]
        let identifier = bookmark.identifier
        
        if self.storageManager.deleteBookmark(given: identifier) {
            self.bookmarks.remove(at: row)
            return .yes
        } else {
            return .no
        }
    }
}
