//
//  CategoryDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation

class CategoryDependencyContainer {
    private let superDependencyContainer: MainDependencyContainer
    private let mainViewModel: MainViewModel
    private let categoryManager: StorageManager
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
        self.categoryManager = superDependencyContainer.getBookmarkManager()
        self.superDependencyContainer = superDependencyContainer
    }
    
    func createGroupsViewController() -> GroupsViewController {
        let viewModel: GroupsViewModel = self.createCategoryViewModel()
        let bookmarkList = { (category: Group) in
            return self.createBookmarksMainNavigationController(category: category)
        }
        
        return .init(viewModel: viewModel, bookmarkListViewController: bookmarkList)
    }
}

private extension CategoryDependencyContainer {
    func createCategoryViewModel() -> GroupsViewModel {
        return .init(bookmarkNavigator: self.mainViewModel,
                     categoryManager: self.categoryManager)
    }
    
    func createBookmarksMainNavigationController(category: Group) -> SubNavigationController {
        let dependencyContainer: SubDependencyContainer = .init(storageManager: self.categoryManager)
        return dependencyContainer.createBookmarksMainNavigationController(group: category)
    }
}
