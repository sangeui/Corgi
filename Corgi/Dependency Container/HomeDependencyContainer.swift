//
//  HomeDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation

class HomeDependencyContainer {
    private let mainViewModel: MainViewModel
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
    }
    
    func createHomeViewController() -> HomeViewController {
        let viewModel: HomeViewModel = self.createHomeViewModel()
        let addition = { (bookmark: UnfinishedBookmark?) in
            return self.createAdditionViewController(homeNavigator: viewModel,
                                                     unstoredBookmark: bookmark) }
        
        return .init(viewModel: viewModel,
                     addition: addition)
    }
}

private extension HomeDependencyContainer {
    func createHomeViewModel() -> HomeViewModel {
        return .init(categoryNavigator: self.mainViewModel,
                     bookmarkNavigator: self.mainViewModel,
                     settingsNavigator: self.mainViewModel)
    }
}

private extension HomeDependencyContainer {
    func createAdditionViewController(homeNavigator: HomeNavigator,
                                      unstoredBookmark: UnfinishedBookmark?) -> AdditionViewController {
        let viewModel: AdditionViewModel = self.createAdditionViewModel(homeNavigator: homeNavigator,
                                                                        unstoredBookmark: unstoredBookmark)
        return .init(viewModel: viewModel,
                     homeNavigator: homeNavigator)
    }
    
    func createAdditionViewModel(homeNavigator: HomeNavigator,
                                 unstoredBookmark: UnfinishedBookmark?) -> AdditionViewModel {
        return .init(homeNavigator: homeNavigator,
                     unstoredBookmark: unstoredBookmark)
    }
}
