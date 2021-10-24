//
//  ContainerView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/20.
//

import UIKit

class ContainerView: View {
    override init() {
        super.init()
        self.setup()
    }
}

private extension ContainerView {
    func setup() {
        self.backgroundColor = .corgi.background.grouped
        self.layer.cornerRadius = 10
        
        let shadow = ShadowViewDecorator()
        self.decorate(with: shadow)
    }
}
