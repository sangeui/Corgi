//
//  CategoryViewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation
import Combine
import UIKit
import CorgiStorage

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
    
    private let groupUseCaseInteractor: GroupUseCaseInteractor = .init(dataAccessInterface: CoreDataInterface()!)
    private let bookmarkNavigator: BookmarkNavigator
    
    init(bookmarkNavigator: BookmarkNavigator) {
        self.bookmarkNavigator = bookmarkNavigator
        self.groupUseCaseInteractor.outputBoundary = self
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
        self.groupUseCaseInteractor.read()
    }
    
    func requestDeletingGroup(_ uuid: UUID) {
        self.groupUseCaseInteractor.delete(uuid: uuid)
    }
    
    func update(group: Group) {
        self.groupUseCaseInteractor.update(group: group)
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

extension GroupsViewModel: GroupUseCaseOutputBoundary {
    func send(groups: [Group]) {
        self.immutableGroups = groups
    }
    
    func message(_ message: GroupUseCaseMessage) {
        switch message {
        case .success(let groupUseCase):
            switch groupUseCase {
            case .update(_): self.groupUseCaseInteractor.read()
            case .delete(_): self.groupUseCaseInteractor.read()
            default: break
            }
        default: break
        }
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
