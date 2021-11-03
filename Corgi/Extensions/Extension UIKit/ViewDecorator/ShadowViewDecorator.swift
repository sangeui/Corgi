//
//  ShadowViewDecorator.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

struct ShadowViewDecorator: ViewDecorator {
    func decorate(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 3)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
//        view.layer.shouldRasterize = true
//        view.layer.rasterizationScale = UIScreen.main.scale
    }
}

struct BottomShadowViewDecorator: ViewDecorator {
    func decorate(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 3)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
    }
}
