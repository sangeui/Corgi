//
//  View.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/05.
//

import UIKit

class View: UIView {
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable, message: "")
    required init?(coder: NSCoder) {
        fatalError()
    }
}

protocol Designable { }
extension Designable where Self: UIView {
    func design(block: (Self) -> Void) {
        block(self)
    }
}

extension UIView: Designable { }
