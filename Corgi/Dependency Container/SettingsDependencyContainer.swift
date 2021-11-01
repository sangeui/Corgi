//
//  SettingsDependencyContainer.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/19.
//

import Foundation

class SettingsDependencyContainer {
    private let mainViewModel: MainViewModel
    private let userInterfaceResponder: UserInterfaceStyleResponder
    
    init(_ superDependencyContainer: MainDependencyContainer) {
        self.mainViewModel = superDependencyContainer.getMainViewModel()
        self.userInterfaceResponder = superDependencyContainer.getUserInterfaceResponder()
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let viewModel: SettingsViewModel = .init(userInterfaceResponder: self.userInterfaceResponder)
        
        return .init(viewModel: viewModel)
    }
}
