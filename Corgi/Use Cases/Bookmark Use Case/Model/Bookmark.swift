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
    var comment: String?
    var identifier: UUID
    var created: Date
    var isOpened: Bool
}

extension Bookmark: Comparable {
    public static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.created > rhs.created
    }
}
