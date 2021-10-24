//
//  Extension+Bool.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import Foundation

extension Bool {
    static var yes: Self { return true }
    static var no: Self { return false }
    
    static var positive: Self { return true }
    static var negative: Self { return false }
}

extension Bool {
    var isNot: Bool { return self == false }
}
