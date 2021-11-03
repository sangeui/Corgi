//
//  Extension+UILayoutGuide.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

extension UILayoutGuide {
    var leading: NSLayoutXAxisAnchor { return self.leadingAnchor }
    var trailing: NSLayoutXAxisAnchor { return self.trailingAnchor }
    var top: NSLayoutYAxisAnchor { return self.topAnchor }
    var bottom: NSLayoutYAxisAnchor { return self.bottomAnchor }
    var centerx: NSLayoutXAxisAnchor { return self.centerXAnchor }
    var centery: NSLayoutYAxisAnchor { return self.centerYAnchor }
    var height: NSLayoutDimension { return self.heightAnchor }
    var width: NSLayoutDimension { return self.widthAnchor }
}
