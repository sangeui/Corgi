//
//  DisabledMessageLabel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/20.
//

import UIKit

class DisabledMessageLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func message(_ message: String) {
        self.text = message
    }
}

private extension DisabledMessageLabel {
    func setup() {
        self.textAlignment = .center
        self.textColor = .corgi.text.secondary
        self.font = .corgi.subTitle4
        self.layer.zPosition = 1
        self.isHidden = .yes
    }
}
