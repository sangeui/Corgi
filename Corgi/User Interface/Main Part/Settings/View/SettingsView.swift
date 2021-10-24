//
//  SettingsView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/21.
//

import UIKit
import MessageUI

class SettingsView: UITableView {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero, style: .plain)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SettingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == .zero, indexPath.row == 1 {
            self.viewModel.present(dialog: .changeUserInterfaceStyle(action: { [weak self] style in
                self?.viewModel.actionForUserInterfaceStyle(style)
                let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell
                cell?.secondaryText = UIUserInterfaceStyle(rawValue: style)?.title ?? ""
            }))
        }
        
        if indexPath.section == .zero, indexPath.row == .zero {
            self.viewModel.present(dialog: .confirm(action: { [weak self] in
                self?.viewModel.clearAllStoredData()
            }))
        }
        
        if indexPath.section == 1, indexPath.row == .zero {
            self.viewModel.present(dialog: .sendEmail)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.systemGray3
    }
}

extension SettingsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSettings()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfSubSettings(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell
        cell?.primaryText = self.viewModel.titleOfSubSetting(of: indexPath.row, in: indexPath.section) ?? ""
        
        if indexPath.section == .zero, indexPath.row == 1,
                  let userInterfaceStyle = UIUserInterfaceStyle(rawValue:(self.viewModel.getAppearance())) {
            if userInterfaceStyle == .dark {
                cell?.secondaryText = LocalizedString("settings_uistyle_dark")
            } else if userInterfaceStyle == .light {
                cell?.secondaryText = LocalizedString("settings_uistyle_light")
            } else {
                cell?.secondaryText = LocalizedString("settings_uistyle_default")
            }
        }
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleOfSetting(of: section)
    }
}

private extension SettingsView {
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.separatorStyle = .none
        self.alwaysBounceVertical = .no
        self.backgroundColor = .corgi.background.base
        self.register(SettingTableViewCell.self, identifier: SettingTableViewCell.reuseIdentifier)
    }
}
