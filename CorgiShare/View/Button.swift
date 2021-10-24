//
//  Button.swift
//  CorgiShare
//
//  Created by 서상의 on 2021/10/04.
//

import UIKit

class Button: UIButton {
    var title: String {
        get { self.titleLabel?.text ?? "" }
        set { self.titleLabel?.text = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension Button {
    func setup() {
        self.backgroundColor = .systemOrange
        self.layer.cornerRadius = 10
    }
}
