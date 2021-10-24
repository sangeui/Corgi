//
//  Extension+Bundle.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/11.
//

import Foundation
import CoreData

internal extension Bundle {
    static let storageBundle: Bundle? = .init(identifier: .identifier)
    
    var modelURL: URL? {
        return self.url(resource: .modelName, ext: .modelEXT)
    }
    
    private func url(resource: String, ext: String) -> URL? {
        self.url(forResource: resource, withExtension: ext)
    }
}

internal extension String {
    static let identifier = "com.sangeui.corgi.CorgiStorage"
    static let modelName = "CDM"
    static let modelEXT = "momd"
    
    static let appGroup = "group.sangeui.core.data"
    static let database = "Corgi"
    
    static let groupEntityName = "GroupCDM"
    static let bookmarkEntityName = "BookmarkCDM"
}

internal extension NSPersistentContainer {
    convenience init(name: String, model: NSManagedObjectModel) {
        self.init(name: name, managedObjectModel: model)
    }
}

internal extension URL {
    static func groupStorage(for appGroup: String, name: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(name).sqlite")
    }
}
