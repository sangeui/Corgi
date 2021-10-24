//
//  Extension+NSPredicate.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/11.
//

import Foundation

extension NSPredicate {
    static func matched(source: CVarArg, with target: CVarArg) -> NSPredicate {
        let format = "%K == %@"
        return .init(format: format, source, target)
    }
}
