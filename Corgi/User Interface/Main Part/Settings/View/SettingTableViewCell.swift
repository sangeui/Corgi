//
//  SettingTableViewCell.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "SettingTableViewCell"
    
    var primaryText: String = "" {
        didSet {
            var configuration = self.contentConfiguration as? UIListContentConfiguration
            configuration?.text = self.primaryText
            
            self.contentConfiguration = configuration
        }
    }
    var secondaryText: String = "" {
        didSet {
            var configuration = self.contentConfiguration as? UIListContentConfiguration
            configuration?.secondaryText = self.secondaryText
            
            self.contentConfiguration = configuration
        }
    }
    
    private let configuration: UIListContentConfiguration = {
        var configuration: UIListContentConfiguration = .valueCell()
        configuration.textProperties.color = .corgi.text.primary
        configuration.textProperties.font = .corgi.subtitle3
        
        return configuration
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension SettingTableViewCell {
    func setup() {
        self.selectionStyle = .none
        self.contentConfiguration = self.configuration
    }
}
