//
//  CaptionLabel.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/20.
//

import UIKit

class CaptionLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func caption(_ message: String) {
        self.text = message
    }
}

private extension CaptionLabel {
    func setup() {
        self.font = .corgi.caption1
        self.textColor = .corgi.text.secondary
    }
}
