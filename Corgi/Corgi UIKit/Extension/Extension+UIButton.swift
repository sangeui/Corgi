//
//  Extension+UIButton.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

extension UIButton {
    convenience init(image: UIImage?) {
        self.init()
        self.setImage(image, for: .normal)
    }
}
