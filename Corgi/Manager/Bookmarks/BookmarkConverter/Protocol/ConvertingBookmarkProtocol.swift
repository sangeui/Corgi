//
//  ConvertingBookmarkProtocol.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/05.
//

import Foundation

protocol ConvertingBookmarkProtocol {
    func from(_ newBookmark: UnfinishedBookmark) -> Bookmark?
}
