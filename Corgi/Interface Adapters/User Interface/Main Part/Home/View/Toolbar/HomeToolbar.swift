//
//  HomeToolbar.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/21.
//

import UIKit

class HomeToolbar: ContainerView {
    var add: (() -> Void)? = nil
    var remove:(() -> Void)? = nil
    var groups: (() -> Void)? = nil
    
    private let toolbar: Toolbar = .init()
    
    override init() {
        super.init()
        self.setup()
    }
}

private extension HomeToolbar {
    
    func setup() {
        self.setupToolbar(self.toolbar, inside: self)
    }
    
    func setupToolbar(_ toolbar: Toolbar, inside parent: UIView) {
        parent.addSubview(toolbar, autolayout: .yes)
        toolbar.stretch(into: parent, padding: .corgi.spacing.padding)
        toolbar.addButton.addAction(.init(handler: { _ in self.add?()
        }), for: .touchUpInside)
        toolbar.removeButton.addAction(.init(handler: { _ in self.remove?()
        }), for: .touchUpInside)
        toolbar.categoryButton.addAction(.init(handler: { _ in self.groups?()
        }), for: .touchUpInside)
    }
}

