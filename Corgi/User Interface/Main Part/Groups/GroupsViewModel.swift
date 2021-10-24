//
//  CategoryViewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation
import Combine
import UIKit

enum CategoryViewType: Equatable {
    case category, bookmarkList(Group)
}

class GroupsViewModel {
    typealias CategoryList = [Group]
    
    @Published public private(set) var groups: [Group] = .empty
    @Published public private(set) var showBookmarks: CategoryViewType = .category
    @Published public private(set) var dialog: GroupsDialog? = nil
    
    var numberOfgroups: Int { return self.groups.count }
    
    private var immutableGroups: [Group] = .empty {
        didSet { self.groups = self.immutableGroups }
    }
    
    private let categoryManager: StorageManager
    private let bookmarkNavigator: BookmarkNavigator
    
    init(bookmarkNavigator: BookmarkNavigator,
         categoryManager: StorageManager) {
        self.bookmarkNavigator = bookmarkNavigator
        self.categoryManager = categoryManager
    }
    
    func groupInformation(of index: Int) -> (name: String, count: Int)? {
        guard index < self.groups.count else { return nil }
        return (self.groups[index].name, self.groups[index].count)
    }
    
    func group(of index: Int) -> Group? {
        guard index < self.groups.count else { return nil }
        return self.groups[index]
    }
    
    func requestCategoryList() {
        self.immutableGroups = self.categoryManager.readAllGroups()
    }
    
    func requestDeletingGroup(_ uuid: UUID) -> Bool {
        if self.categoryManager.deleteGroup(group: uuid) {
            self.requestCategoryList()
            return true
        } else {
            return false
        }
    }
    
    func update(group: Group) {
        self.categoryManager.editGroupName(group: group)
    }
    
    func presentBookmarkList(of group: Int) {
        self.present(category: self.groups[group])
    }
    
    func presented(view: CategoryViewType) {
        self.showBookmarks = view
    }
    
    func search(_ text: String) {
        guard text.isEmpty.isNot else { self.resetGroups(); return }
        self.groups = self.immutableGroups.filter({ $0.name.contains(text)})
    }
    
    func dialog(_ dialog: GroupsDialog?) {
        self.dialog = dialog
    }
}

extension GroupsViewModel: BookmarkListPresentor {
    func present(category: Group) {
        self.showBookmarks = .bookmarkList(category)
    }
}

private extension GroupsViewModel {
    func resetGroups() {
        self.groups = self.immutableGroups
    }
}

enum GroupsDialog {
    case confirm(action: () -> Void)
    case editGroup(group: Group)
    case editBookmark(bookmark: Bookmark)
}
