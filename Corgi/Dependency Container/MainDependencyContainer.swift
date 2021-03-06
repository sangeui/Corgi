//
//  SuperDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import Foundation
import CorgiStorage

class MainDependencyContainer {
    private let mainViewModel: MainViewModel
    private let userInterfaceResponder: UserInterfaceStyleResponder
    
    init?(userInterfaceResponder: UserInterfaceStyleResponder) {
        self.userInterfaceResponder = userInterfaceResponder
        self.mainViewModel = .init()
    }
    
    func getMainViewModel() -> MainViewModel {
        return self.mainViewModel
    }
    
    func getUserInterfaceResponder() -> UserInterfaceStyleResponder {
        return self.userInterfaceResponder
    }
    
    func createMainViewController() -> MainNavigationController {
        let home = self.createHomeViewController()
        
        let category = { return self.creaetCategoryViewController() }
        let bookmark = { (bookmark: Bookmark) in
            return self.createBookmarkViewController(bookmark: bookmark) }
        let settings = { return self.createSettingsViewController() }
        
        return .init(viewModel: self.mainViewModel,
                     home: home,
                     category: category,
                     bookmark: bookmark,
                     settings: settings)
    }
}

private extension MainDependencyContainer {
    func createHomeViewController() -> HomeViewController {
        let dependencyContainer: HomeDependencyContainer = .init(self)
        return dependencyContainer.createHomeViewController()
    }
    
    func creaetCategoryViewController() -> GroupsViewController {
        let dependencyContainer: CategoryDependencyContainer = .init(self)
        return dependencyContainer.createGroupsViewController()
    }
    
    func createBookmarkViewController(bookmark: Bookmark) -> BookmarkViewController {
        let dependencyContainer: BookmarkDependencyContainer = .init(self)
        return dependencyContainer.createBookmarkViewController(bookmark: bookmark)
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let dependencyContainer: SettingsDependencyContainer = .init(self)
        return dependencyContainer.createSettingsViewController()
    }
}

class MockBookmarkNavigator: BookmarkNavigator {
    func navigateToBookmark(bookmark: Bookmark) { }
}
