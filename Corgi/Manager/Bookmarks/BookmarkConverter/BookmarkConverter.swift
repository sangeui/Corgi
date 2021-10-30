//
//  BookmarkConverter.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/05.
//

import Foundation

class BookmarkConverter: ConvertingBookmarkProtocol {
    func from(_ newBookmark: UnfinishedBookmark) -> Bookmark? {
        guard let urlString = newBookmark.addressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let bookmarkAddress = URL(string: urlString) else { return nil }
        
        let bookmarkDescription = newBookmark.description
        let bookmarkCategory = newBookmark.category
        
        return .init(url: bookmarkAddress,
                     group: bookmarkCategory,
                     comment: bookmarkDescription,
                     identifier: .init(),
                     created: .init(),
                     isOpened: false)
    }
}
