//
//  LocalizedString.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/24.
//

import Foundation

func LocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
}
