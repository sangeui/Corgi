//
//  CorgiCoreBookmark.swift
//  Corgi
//
//  Created by 서상의 on 2021/09/29.
//

import Foundation

public typealias BookmarkRMs = [BookmarkRM]

public struct BookmarkRM {
    public var url: URL
    public var group: String?
    public var description: String?
    public var identifier: UUID
    public var dateCreated: Date
    public var isOpened: Bool
    
    public init(url: URL, group: String? = nil, description: String? = nil, identifier: UUID, dateCreated: Date, isOpened: Bool) {
        self.url = url
        self.group = group
        self.description = description
        self.identifier = identifier
        self.dateCreated = dateCreated
        self.isOpened = isOpened
    }
}

public struct GroupRM {
    public var identifier: UUID
    public var name: String
    public var count: Int
    
    public init(identifier: UUID, name: String, count: Int) {
        self.identifier = identifier
        self.name = name
        self.count = count
    }
}
