//
//  SavingBookmarkError.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/05.
//

import Foundation

enum SavingBookmarkError: Error {
    case convertingError
    case savingError
    case hasEqualNameAlready
}
