//
//  Extension+Array.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/06.
//

import Foundation

extension Array where Element: Equatable {
    func isEqual(with other: Self) -> Bool {
        return self == other
    }
}

extension Array {
    static var empty: Self { return [] }
}
