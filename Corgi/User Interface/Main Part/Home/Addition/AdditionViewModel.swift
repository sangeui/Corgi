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
    private let groupUseCaseInteractor: GroupUseCaseInteractor = .init(dataAccessInterface: CoreDataInterface()!)
    
    private let homeNavigator: HomeNavigator
    
    private var enteredURLtext: String = .empty
    private var enteredCategory: String = .empty
    private var enteredDescription: String = .empty
    
    init(homeNavigator: HomeNavigator,
         unstoredBookmark: UnfinishedBookmark?) {
        self.homeNavigator = homeNavigator
        self.unfinishedBookmark = unstoredBookmark
        
        self.bookmarkUseCaseInteractor.outputBoundary = self
        self.groupUseCaseInteractor.outputBoundary = self
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
        self.groupUseCaseInteractor.read()
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

extension AdditionViewModel: GroupUseCaseOutputBoundary {
    func send(groups: [Group]) {
        self.categoryList = groups
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
