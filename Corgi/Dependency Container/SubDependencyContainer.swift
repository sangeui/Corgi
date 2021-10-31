//
//  BookmarksDependencyContainer.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/15.
//

import UIKit

class SubDependencyContainer {
    private let bookmarksMainViewModel: BookmarksMainViewModel
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.bookmarksMainViewModel = .init()
        self.storageManager = storageManager
    }
    
    func getBookmarksMainViewModel() -> BookmarksMainViewModel {
        return self.bookmarksMainViewModel
    }
    
    func getStorageManager() -> StorageManager {
        return self.storageManager
    }
    
    func createBookmarksMainNavigationController(group: Group) -> SubNavigationController {
        let bookmarks = { (group: Group) in
            return self.createBookmarksViewController(group: group)
        }
        
        let bookmark = { (bookmark: Bookmark) in
            return self.createBookmarkViewController(bookmark: bookmark)
        }
        
        let controller: SubNavigationController = .init(viewModel: self.bookmarksMainViewModel, bookmarks: bookmarks, bookmark: bookmark)
        controller.pushViewController(bookmarks(group), animated: .no)
        
        return controller
    }
}

private extension SubDependencyContainer {
    func createBookmarksViewController(group: Group) -> BookmarksViewController {
        let container = BookmarksDependencyContainer(self)
        return container.createBookmarksViewController(group: group)
    }
    
    func createBookmarkViewController(bookmark: Bookmark) -> BookmarkViewController {
        let viewModel: BookmarkViewModel = .init(bookmark: bookmark)
        return .init(viewModel: viewModel)
    }
}

class BookmarksDependencyContainer {
    private let bookmarksMainViewModel: BookmarksMainViewModel
    private let storageManager: StorageManager
    
    init(_ bookmarksMainDependencyContainer: SubDependencyContainer) {
        self.bookmarksMainViewModel = bookmarksMainDependencyContainer.getBookmarksMainViewModel()
        self.storageManager = bookmarksMainDependencyContainer.getStorageManager()
    }
    
    func createBookmarksViewController(group: Group) -> BookmarksViewController {
        let viewModel: BookmarksViewModel = .init(bookmarkNavigator: self.bookmarksMainViewModel, category: group)
        let groupSelect = {
            return self.createGroupSelectViewController()
        }
        return .init(viewModel: viewModel, groupSelect: groupSelect)
    }
}

private extension BookmarksDependencyContainer {
    func createGroupSelectViewController() -> GroupSelectViewController {
        let viewModel = GroupSelectViewModel(storageManager: self.storageManager)
        return .init(viewModel: viewModel)
    }
}
