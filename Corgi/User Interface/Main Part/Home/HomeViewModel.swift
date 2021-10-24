//
//  HomeViewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import Foundation
import OSLog

protocol UnstoredBookmarkHandler {
    func haveUnstoredBookmark(_ bookmark: UnfinishedBookmark)
}

enum HomeViewType: Equatable {
    case home, addition(UnfinishedBookmark?)
}

class HomeViewModel {
    @Published public private(set) var showingAdditionView: HomeViewType = .home {
        didSet {
            print(self.showingAdditionView)
        }
    }
    @Published public private(set) var unstoredBookmark: UnfinishedBookmark? = nil
    @Published public private(set) var bookmarkList: Bookmarks = .empty
    @Published public private(set) var url: URL? = nil
    
    private let categoryNavigator: CategoryNavigator
    private let bookmarkNavigator: BookmarkNavigator
    private let settingsNavigator: SettingsNavigator
    
    private let bookmarkManager: StorageManager
    
    init(categoryNavigator: CategoryNavigator,
         bookmarkNavigator: BookmarkNavigator,
         settingsNavigator: SettingsNavigator,
         bookmarkManager: StorageManager) {
        self.categoryNavigator = categoryNavigator
        self.bookmarkNavigator = bookmarkNavigator
        self.settingsNavigator = settingsNavigator
        self.bookmarkManager = bookmarkManager
    }
    
    @objc func showAdditionView() {
        self.showingAdditionView = .addition(self.unstoredBookmark)
    }
    
    func showAdditionViewWithBookmark(_ bookmark: UnfinishedBookmark?) {
        self.showingAdditionView = .addition(bookmark)
    }
    
    @objc func showCategoryView() {
        self.categoryNavigator.navigateToCategory()
    }
    
    @objc func showSettingsView() {
        self.settingsNavigator.navigateToSettings()
    }
    
    func showBookmarkView(with bookmark: Bookmark) {
        var copiedBookmark = bookmark
        copiedBookmark.isOpened = .yes
        self.bookmarkManager.update(bookmark: copiedBookmark)
        self.bookmarkNavigator.navigateToBookmark(bookmark: bookmark)
    }
    
    @objc func updateBookmarkList() {
        self.bookmarkList = self.bookmarkManager.readAllBookmarks()
    }
    
    @objc func removeBookmark(given row: Int) -> Bool {
        let bookmark = self.bookmarkList[row]
        let identifier = bookmark.identifier
        
        if self.bookmarkManager.deleteBookmark(given: identifier) {
            self.bookmarkList.removeAll(where: { $0 == bookmark })
            return .yes
        } else {
            return .no
        }
    }
    
    func faviconImageURL(of index: Int) -> URL? {
        let url = self.bookmarkList[index].url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: .no)
        
        let faviconURLstring = "https://\(components?.host ?? "")/favicon.ico"
        return URL(string: faviconURLstring)
    }
    
    func pasteURL(_ url: URL?) {
        self.url = url
    }
}

extension HomeViewModel: HomeNavigator {
    func navigateToHome() {
        self.showingAdditionView = .home
    }
}

extension HomeViewModel: UnstoredBookmarkHandler {
    func haveUnstoredBookmark(_ bookmark: UnfinishedBookmark) {
        self.unstoredBookmark = bookmark
    }
}
