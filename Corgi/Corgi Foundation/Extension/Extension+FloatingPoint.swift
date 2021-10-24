//
//  Extension+FloatingPoint.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/14.
//

import Foundation

extension FloatingPoint {
    var anHalf: Self { return self / 2 }
}

extension Numeric {
    var numberingFromZero: Self { return self - 1 }
    var minus: Self { return self * -1}
}
