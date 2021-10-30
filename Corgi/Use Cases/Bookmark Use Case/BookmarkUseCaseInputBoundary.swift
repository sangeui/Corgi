//
//  BookmarkUseCaseInputBoundary.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

protocol BookmarkUseCaseInputBoundary {
    func create(url: String, comment: String, group: String)
    func read()
    func read(group: UUID)
    func update(bookmark: Bookmark)
    func delete(_ uuid: UUID)
}
