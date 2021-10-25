//
//  NeumorphicButton.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/13.
//

import UIKit

class NeumorphicButton: UIButton {
    private let darkSideLayer: CALayer = .init()
    private let lightSideLayer: CALayer = .init()
    
    override var isHighlighted: Bool {
        didSet {
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "")
    required init?(coder: NSCoder) {
        fatalError()
    }
}
