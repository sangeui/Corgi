//
//  Extension+NSLayoutConstraint.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

extension NSLayoutConstraint {
    var active: Void { self.isActive = true }
    var deactive: Void { self.isActive = false }
    
    @discardableResult
    func activeAndReturn() -> Self {
        self.isActive = true
        return self
    }
    
    @discardableResult
    func deactiveAndReturn() -> Self {
        self.isActive = false
        return self
    }
}

extension NSLayoutAnchor {
    @objc func pin(equalTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor)
    }

    @objc func pin(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor)
    }

    @objc func pin(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor)
    }

    @objc func pin(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, constant: c)
    }

    @objc func pin(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, constant: c)
    }

    @objc func pin(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, constant: c)
    }
}

extension NSLayoutDimension {
    
    @objc func pin(equalToConstant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalToConstant: c)
    }

    @objc func pin(greaterThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualToConstant: c)
    }

    @objc func pin(lessThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualToConstant: c)
    }

    @objc func pin(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, multiplier: m)
    }

    @objc func pin(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, multiplier: m)
    }

    @objc func pin(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, multiplier: m)
    }

    @objc func pin(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, multiplier: m, constant: c)
    }

    @objc func pin(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualTo: anchor, multiplier: m, constant: c)
    }

    @objc func pin(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualTo: anchor, multiplier: m, constant: c)
    }
}
