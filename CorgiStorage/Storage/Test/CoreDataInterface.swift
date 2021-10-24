//
//  CorgiCoreData.swift
//  CorgiStorage
//
//  Created by 서상의 on 2021/10/09.
//

import CoreData

public class CoreDataInterface {
    private var container: NSPersistentContainer!
    private var bookmarkStorage: CoreDataBookmark!
    private var groupStorage: CoreDataGroup!
    
    public init?() {
        guard let url = self.modelURL else { return nil }
        guard let model = self.managedObjectModel(url: url) else { return nil }
        
        self.container = .init(name: "CD", model: model)
        let storeURL = URL.groupStorage(for: .appGroup, name: .database)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        self.container.persistentStoreDescriptions = [storeDescription]
        self.container.loadPersistentStores(completionHandler: { description, error in
            if let _ = error { }
        })
        
        self.bookmarkStorage = .init(self.container.viewContext)
        self.groupStorage = .init(self.container.viewContext)
    }
    
    // MARK: - General
    
    // 모든 데이터 삭제하기
    public func reset() -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: .groupEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try self.container.persistentStoreCoordinator.execute(deleteRequest, with: self.container.viewContext)
            return true
        } catch let error as NSError {
            return false
        }
    }
    
    // MARK: - Bookmark
    
    // 새 북마크 저장하기
    public func createBookmark(_ bookmark: BookmarkRM) -> Bool {
        return self.bookmarkStorage.create(bookmark)
    }
    
    // 모든 북마크 읽기
    public func readBookmarks(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [BookmarkRM] {
        return self.bookmarkStorage.readAll(predicate: predicate, sort: sort)
    }
    
    // 특정 그룹의 모든 북마크 읽기
    public func readBookmarks(of group: UUID) -> [BookmarkRM] {
        let predicate: NSPredicate = .init(format: "%K == %@", #keyPath(BookmarkCDM.group.identifier), group as CVarArg)
        return self.bookmarkStorage.readAll(predicate: predicate)
    }
    
    // 기존 북마크 갱신하기
    public func updateBookmark(_ bookmark: BookmarkRM) -> Bool {
        return self.bookmarkStorage.update(bookmark)
    }
    
    // 기존 북마크 삭제하기
    public func deleteBookmark(_ identifier: UUID) -> Bool {
        return self.bookmarkStorage.delete(identifier)
    }
    
    // MARK: - Group
    
    // 모든 그룹 읽기
    public func readGroups(predicate: NSPredicate?, sort: NSSortDescriptor?) -> [GroupRM] {
        return self.groupStorage.readAll(predicate: predicate, sort: sort)
    }
    
    public func updateGroup(_ group: GroupRM) -> Bool {
        return self.groupStorage.update(group)
    }
    
    public func deleteGroup(_ identifier: UUID) -> Bool {
        return self.groupStorage.delete(identifier)
    }
}

private extension CoreDataInterface {
    var modelURL: URL? {
        guard let bundle: Bundle = .storageBundle else { return nil }
        return bundle.modelURL
    }
    
    func managedObjectModel(url: URL) -> NSManagedObjectModel? {
        return .init(contentsOf: url)
    }
}
