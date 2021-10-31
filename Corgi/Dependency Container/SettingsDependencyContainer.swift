//
//  SettingsDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/19.
//

import Foundation

class SettingsDependencyContainer {
    private let mainViewModel: MainViewModel
    private let appearanceManager: AppearanceManager
    private let userInterfaceResponder: UserInterfaceStyleResponder
    private let storageManager: StorageManager
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
        self.appearanceManager = superDependencyContainer.getAppearanceManager()
        self.userInterfaceResponder = superDependencyContainer.getUserInterfaceResponder()
        self.storageManager = superDependencyContainer.getBookmarkManager()
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewModel: SettingsViewModel = .init(appearanceManager: self.appearanceManager,
                                                 userInterfaceResponder: self.userInterfaceResponder)
        
        return .init(viewModel: viewModel)
    }
}
