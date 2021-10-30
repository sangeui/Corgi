//
//  AdditionViewModel.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import Foundation
import Combine
import CorgiStorage

class AdditionViewModel {
    typealias CategoryList = [Group]
    
    @Published public private(set) var buttonEnabled: Bool = .no
    @Published public private(set) var categoryList: CategoryList = []
    @Published public private(set) var unfinishedBookmark: UnfinishedBookmark? = nil
    
    private let bookmarkUseCaseInteractor: BookmarkUseCaseInteractor = .init(dataAccessInterface: CoreDataInterface()!)
    private let bookmarkManager: StorageManager
    private let homeNavigator: HomeNavigator
    
    private var enteredURLtext: String = .empty
    private var enteredCategory: String = .empty
    private var enteredDescription: String = .empty
    
    init(bookmarkManager: StorageManager,
         homeNavigator: HomeNavigator,
         unstoredBookmark: UnfinishedBookmark?) {
        self.bookmarkManager = bookmarkManager
        self.homeNavigator = homeNavigator
        self.unfinishedBookmark = unstoredBookmark
        
        self.bookmarkUseCaseInteractor.outputBoundary = self
    }
    
    func userDidEnterURLtext(urlText: String) {
        self.enteredURLtext = urlText
        self.buttonEnabled = self.isEveryFieldDidEntered
    }
    
    func userDidEnterCategory(category: String) {
        self.enteredCategory = category
        self.buttonEnabled = self.isEveryFieldDidEntered
    }
    
    func userDidEnterDescription(description: String) {
        self.enteredDescription = description
        self.buttonEnabled = self.isEveryFieldDidEntered
    }
    
    func requestCategoryList() {
        self.categoryList = self.bookmarkManager.readAllGroups()
    }
    
    @objc func userDidTouchSaveButton() {
        self.bookmarkUseCaseInteractor.create(url: self.enteredURLtext, comment: self.enteredDescription, group: self.enteredCategory)
    }
}

extension AdditionViewModel: BookmarkUseCaseOutputBoundary {
    func message(_ message: BookmarkUseCaseMessage) {
        if case .success(.create(_)) = message {
            self.homeNavigator.navigateToHome()
        }
    }
}

private extension AdditionViewModel {
    var isEveryFieldDidEntered: Bool {
        return
            self.enteredURLtext.isEmpty.isNot &&
            self.enteredCategory.isEmpty.isNot &&
            self.enteredDescription.isEmpty.isNot
    }
}
