//
//  BookmarkDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation

class BookmarkDependencyContainer {
    private let mainViewModel: MainViewModel
    private let bookmarkManager: StorageManager
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
        self.bookmarkManager = superDependencyContainer.getBookmarkManager()
    }
    
    func createBookmarkViewController(bookmark: Bookmark) -> BookmarkViewController {
        let viewModel: BookmarkViewModel = self.createBookmarkViewModel(bookmark: bookmark)
        return .init(viewModel: viewModel)
    }
}

private extension BookmarkDependencyContainer {
    func createBookmarkViewModel(bookmark: Bookmark) -> BookmarkViewModel {
        return .init(bookmarkManager: self.bookmarkManager, bookmark: bookmark)
    }
}
