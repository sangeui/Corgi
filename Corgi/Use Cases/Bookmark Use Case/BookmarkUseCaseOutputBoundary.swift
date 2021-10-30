//
//  BookmarkUseCaseOutputBoundary.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

enum BookmarkUseCaseMessage {
    case success(BookmarkUseCase)
    case failure(BookmarkUseCase)
}

enum BookmarkUseCase {
    case create(String? = nil),
         read(String? = nil),
         update(String? = nil),
         delete(String? = nil)
}

protocol BookmarkUseCaseOutputBoundary: AnyObject {
    func send(bookmarks: [Bookmark])
    func message(_ message: BookmarkUseCaseMessage)
}
