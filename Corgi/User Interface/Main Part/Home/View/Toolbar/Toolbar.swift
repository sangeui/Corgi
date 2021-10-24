//
//  HomeToolBar.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

class Toolbar: View {
    let removeButton: ToolbarButton = .init(type: .remove)
    let addButton: ToolbarButton = .init(type: .add)
    let categoryButton: ToolbarButton = .init(type: .category)
    
    private let stackView: UIStackView = .init()
    
    override init() {
        super.init()
        
        self.setup()
    }
}

private extension Toolbar {
    func setup() {
        self.setupStackView(self.stackView)
    }
    
    func setupStackView(_ stackView: UIStackView) {
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        self.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: self.leading, constant: .corgi.spacing.margin).active
        stackView.trailing.pin(equalTo: self.trailing, constant: .corgi.spacing.margin.minus).active
        stackView.top.pin(equalTo: self.top).active
        stackView.bottom.pin(equalTo: self.bottom).active
        
        [self.removeButton, self.addButton, self.categoryButton].forEach({ stackView.addArrangedSubview($0) })
    }
}
