//
//  BorderDecorator.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/14.
//

import UIKit

struct BorderDecorator: ViewDecorator {
    func decorate(view: UIView) {
        view.layer.borderWidth = .borderWidth
        view.layer.borderColor = .borderColor
    }
}

private extension CGFloat {
    static var borderWidth: Self { return 1 }
}

private extension CGColor {
    static var borderColor: CGColor { return UIColor.systemGray6.cgColor }
}

struct BottomBorderDecorator: ViewDecorator {
    func decorate(view: UIView) {
        let bottomBorder: View = .init()
        
        view.addSubview(bottomBorder, autolayout: .yes)
        
        bottomBorder.leading.constraint(equalTo: view.leading).active
        bottomBorder.trailing.constraint(equalTo: view.trailing).active
        bottomBorder.bottom.constraint(equalTo: view.bottom).active
        bottomBorder.height.constraint(equalToConstant: .borderWidth).active
        
        bottomBorder.backgroundColor = .systemGray6
    }
}
