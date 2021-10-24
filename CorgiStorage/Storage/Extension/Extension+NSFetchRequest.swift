//
//  Extension+NSFetchRequest.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/11.
//

import CoreData

internal extension NSFetchRequest where ResultType == BookmarkCDM {
    static var bookmarkCDM: NSFetchRequest {
        return .init(entityName: "BookmarkCDM")
    }
}

internal extension NSFetchRequest where ResultType == GroupCDM {
    static var groupCDM: NSFetchRequest {
        return .init(entityName: "GroupCDM")
    }
}
