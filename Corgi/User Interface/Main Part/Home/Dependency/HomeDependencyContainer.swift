//
//  HomeDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation

class HomeDependencyContainer {
    private let mainViewModel: MainViewModel
    private let bookmarkManager: StorageManager
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
        self.bookmarkManager = superDependencyContainer.getBookmarkManager()
    }
    
    func createHomeViewController() -> HomeViewController {
        let viewModel: HomeViewModel = self.createHomeViewModel()
        let addition = { (bookmark: UnfinishedBookmark?) in
            return self.createAdditionViewController(homeNavigator: viewModel,
                                                     unstoredBookmarkHandler: viewModel,
                                                     unstoredBookmark: bookmark) }
        
        return .init(viewModel: viewModel,
                     addition: addition)
    }
}

private extension HomeDependencyContainer {
    func createHomeViewModel() -> HomeViewModel {
        return .init(categoryNavigator: self.mainViewModel,
                     bookmarkNavigator: self.mainViewModel,
                     settingsNavigator: self.mainViewModel,
                     bookmarkManager: self.bookmarkManager)
    }
}

private extension HomeDependencyContainer {
    func createAdditionViewController(homeNavigator: HomeNavigator,
                                      unstoredBookmarkHandler: UnstoredBookmarkHandler,
                                      unstoredBookmark: UnfinishedBookmark?) -> AdditionViewController {
        let viewModel: AdditionViewModel = self.createAdditionViewModel(homeNavigator: homeNavigator,
                                                                        unstoredBookmarkHandler: unstoredBookmarkHandler,
                                                                        unstoredBookmark: unstoredBookmark)
        return .init(viewModel: viewModel,
                     homeNavigator: homeNavigator)
    }
    
    func createAdditionViewModel(homeNavigator: HomeNavigator,
                                 unstoredBookmarkHandler: UnstoredBookmarkHandler,
                                 unstoredBookmark: UnfinishedBookmark?) -> AdditionViewModel {
        return .init(bookmarkManager: self.bookmarkManager,
                     homeNavigator: homeNavigator,
                     unstoredBookmarkHandler: unstoredBookmarkHandler,
                     unstoredBookmark: unstoredBookmark)
    }
}
