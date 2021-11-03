//
//  MainVIewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import Foundation
import Combine

enum Navigation<ViewType>: Equatable where ViewType: Equatable {
    case present(view: ViewType)
    case presented(view: ViewType)
}

class MainViewModel {
    @Published public private(set) var view1: Navigation<MainViewType> = .present(view: .home)
    
    func viewDidNavigate(to view: MainViewType) {
        self.view1 = .presented(view: view)
    }
}

extension MainViewModel: CategoryNavigator {
    func navigateToCategory() {
        self.view1 = .present(view: .category)
    }
}

extension MainViewModel: BookmarkNavigator {
    func navigateToBookmark(bookmark: Bookmark) {
        self.view1 = .present(view: .bookmark(bookmark))
    }
}

extension MainViewModel: SettingsNavigator {
    func navigateToSettings() {
        self.view1 = .present(view: .settings)
    }
}

enum MainViewType: Equatable {
    case home
    case category
    case bookmark(Bookmark)
    case bookmarkWithoutBookmark
    case settings
}
