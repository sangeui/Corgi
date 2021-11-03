//
//  CornerRadiusViewDecorator.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

enum Corner: CaseIterable {
    case leftTop, rightTop
    case leftBottom, rightBottom
    
    var cornerMask: CACornerMask {
        switch self {
        case .leftTop: return .layerMinXMinYCorner
        case .rightTop: return .layerMaxXMinYCorner
        case .leftBottom: return .layerMinXMaxYCorner
        case .rightBottom: return .layerMaxXMaxYCorner
        }
    }
}

struct CornerRadiusViewDecorator: ViewDecorator {
    private let corner: [CACornerMask]
    private let point: CGFloat
    
    init(corner: [Corner] = Corner.allCases, point: CGFloat = 10) {
        self.corner = corner.map({ $0.cornerMask })
        self.point = point
    }
    
    func decorate(view: UIView) {
        view.layer.cornerRadius = point
        view.layer.maskedCorners = CACornerMask(self.corner)
    }
}
