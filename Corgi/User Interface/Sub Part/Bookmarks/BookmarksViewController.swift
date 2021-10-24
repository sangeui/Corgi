//
//  BookmarkListViewController.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/04.
//

import UIKit

class BookmarksViewController: ViewController, TitleImageViewSettable {
    private let viewModel: BookmarksViewModel
    private let groupSelect: () -> GroupSelectViewController
    
    init(viewModel: BookmarksViewModel,
         groupSelect: @escaping () -> GroupSelectViewController) {
        self.viewModel = viewModel
        self.groupSelect = groupSelect
        super.init()
    }
    
    override func loadView() {
        let bookmarksView = BookmarksView(viewModel: self.viewModel)
        bookmarksView.delegate = self
        self.view = bookmarksView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestBookmarkList()
        self.titleImageView(with: .init(named: "Bookmarks Title"))
        
        let symbolConfiguration: UIImage.SymbolConfiguration = .init(pointSize: 12)
        let image: UIImage? = .init(systemName: "chevron.backward", withConfiguration: symbolConfiguration)
        
        let barButtonItem: UIBarButtonItem = .init()
        barButtonItem.image = image
        barButtonItem.tintColor = .label
        
        self.navigationItem.hidesBackButton = .no
    }
}

extension BookmarksViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DynamicHeightPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension BookmarksViewController: TestDelegate {
    func openTest() {
        let controller = self.groupSelect()
        controller.action = self.groupDidSelect(_:)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: .yes, completion: nil)
    }
    
    private func groupDidSelect(_ group: Group) {
        self.viewModel.change(to: group)
    }
}
