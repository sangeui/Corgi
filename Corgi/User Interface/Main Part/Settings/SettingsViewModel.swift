//
//  SettingsViewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/21.
//

import Foundation
import Combine

class SettingsViewModel {
    @Published public private(set) var dialog: SettingsDialog? = nil
    
    private let appearanceManager: AppearanceManager
    private let userInterfaceResponder: UserInterfaceStyleResponder
    private let storageManager: StorageManager
    
    init(appearanceManager: AppearanceManager,
         userInterfaceResponder: UserInterfaceStyleResponder,
         storageManager: StorageManager) {
        self.appearanceManager = appearanceManager
        self.userInterfaceResponder = userInterfaceResponder
        self.storageManager = storageManager
    }
    
    func setAppearance(style: Int) {
        self.appearanceManager.setAppearance(to: style)
    }
    
    func getAppearance() -> Int {
        return self.appearanceManager.getAppearance() ?? .zero
    }
    
    func actionForUserInterfaceStyle(_ style: Int) {
        self.appearanceManager.setAppearance(to: style)
        self.userInterfaceResponder.transition(to: style)
    }
    
    func present(dialog: SettingsDialog?) {
        self.dialog = dialog
    }
    
    func clearAllStoredData() {
        self.storageManager.reset()
    }
}

// MARK: - Settings
extension SettingsViewModel {
    func numberOfSettings() -> Int {
        return Settings.allCases.count
    }
    
    func titleOfSetting(of index: Int) -> String? {
        guard index.isLessThan(Settings.allCases.count) else { return nil }
        return Settings.allCases[index].title
    }
    
    func numberOfSubSettings(_ index: Int) -> Int {
        guard index.isLessThan(Settings.allCases.count) else { return .zero }
        
        let setting = Settings.allCases[index]
        
        switch setting {
        case .normal: return Normal.allCases.count
        case .others: return Others.allCases.count
        }
    }
    
    func titleOfSubSetting(of subIndex: Int, in superIndex: Int) -> String? {
        guard superIndex.isLessThan(Settings.allCases.count) else { return nil }
        
        let setting = Settings.allCases[superIndex]
        
        switch setting {
        case .normal: return Normal.allCases[subIndex].title
        case .others: return Others.allCases[subIndex].title
        }
    }
}

extension SettingsViewModel {
    enum Settings: CaseIterable {
        case normal, others
        
        var title: String {
            switch self {
            case .normal: return LocalizedString("settings_title_normal")
            case .others: return LocalizedString("settings_title_others")
            }
        }
    }
    
    enum Normal: CaseIterable {
        case clearData, appearance
        
        var title: String {
            switch self {
            case .clearData: return LocalizedString("settings_title_normal_clear")
            case .appearance: return LocalizedString("settings_title_normal_uistyle")
            }
        }
    }
    
    enum Others: CaseIterable {
        case improvement
        
        var title: String {
            switch self {
            case .improvement: return LocalizedString("settings_title_others_feedback")
            }
        }
    }
}

enum SettingsDialog {
    case changeUserInterfaceStyle(action: (Int) -> Void)
    case confirm(action: () -> Void)
    case sendEmail
}
