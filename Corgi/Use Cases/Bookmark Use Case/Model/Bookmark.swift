//
//  Bookmark.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/04.
//

import Foundation

public typealias Bookmarks = [Bookmark]

public struct Bookmark: Equatable {
    var url: URL
    var group: String?
    var explanation: String?
    var identifier: UUID
    var created: Date
    var isOpened: Bool
}