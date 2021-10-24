//
//  CategoryViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit
import Combine

class GroupsViewController: ViewController, TitleImageViewSettable {
    private let viewModel: GroupsViewModel
    
    private let bookmarkListViewController: (Group) -> SubNavigationController
    
    private let searchController: UISearchController = .init(searchResultsController: nil)
    private let keyboardObserver: KeyboardObserver = .shared
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(viewModel: GroupsViewModel,
         bookmarkListViewController: @escaping (Group) -> SubNavigationController) {
        self.viewModel = viewModel
        self.bookmarkListViewController = bookmarkListViewController
        super.init()
        self.view.backgroundColor = .systemBackground
    }
    
    override func loadView() {
        self.view = GroupsView(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestCategoryList()
        self.titleImageView(with: .init(named: "Group Title"))
        self.subscribe(to: self.viewModel.$showBookmarks.eraseToAnyPublisher())
        self.subscribe(to: self.viewModel.$dialog.eraseToAnyPublisher())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .corgi.text.primary
    }
    
    deinit {
        self.keyboardObserver.unsubscribe(target: self)
        self.keyboardObserver.unsubscribe(target: self.view as? GroupsView)
        (self.view as? GroupsView)?.subviews.forEach(self.keyboardObserver.unsubscribe(target:))
    }
}

extension GroupsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingClosePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private extension GroupsViewController {
    func subscribe(to publisher: AnyPublisher<CategoryViewType, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewType in
                switch viewType {
                case .category: return
                case .bookmarkList(let group): self?.presentBookmarksMainViewController(group: group)
                }
            }
            .store(in: &self.subscriptions)
    }
    
    func subscribe(to publisher: AnyPublisher<GroupsDialog?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] in self?.presentDialog($0) }
            .store(in: &self.subscriptions)
    }
}

private extension GroupsViewController {
    func presentDialog(_ dialog: GroupsDialog) {
        switch dialog {
        case .confirm(let action):
            let controller = UIAlertController()
            controller.title = LocalizedString("groups_dialog_delete_title")
            controller.message = LocalizedString("groups_dialog_delete_content")
            
            let cancel = UIAlertAction(title: LocalizedString("groups_dialog_cancel"), style: .default, handler: { _ in })
            let confirm = UIAlertAction(title: LocalizedString("groups_dialog_confirm"), style: .destructive, handler: { _ in action() })
            
            cancel.setValue(UIColor.label, forKey: "titleTextColor")
            controller.addAction(confirm)
            controller.addAction(cancel)
            
            self.present(controller, animated: .yes, completion: nil)
        case .editGroup(var group):
            let controller = UIAlertController(title: LocalizedString("groups_dialog_edit_name_title"), message: nil, preferredStyle: .alert)
            controller.addTextField { textField in
                textField.text = group.name
            }
            
            let cancel = UIAlertAction(title: LocalizedString("groups_dialog_cancel"), style: .default, handler: { _ in })
            let confirm = UIAlertAction(title: LocalizedString("groups_dialog_confirm"), style: .default, handler: { _ in
                let text = (controller.textFields?.first?.text ?? .empty).trimmingCharacters(in: .whitespacesAndNewlines)
                
                if text.isEmpty.isNot {
                    group.name = text
                    self.viewModel.update(group: group)
                }
            })
            confirm.setValue(UIColor.systemOrange, forKey: "titleTextColor")
            cancel.setValue(UIColor.label, forKey: "titleTextColor")
            
            controller.addAction(confirm)
            controller.addAction(cancel)
            
            self.present(controller, animated: .yes, completion: nil)
        default: break
        }
    }
    
    func presentBookmarksMainViewController(group: Group) {
        let controller = self.bookmarkListViewController(group)
        controller.modalPresentationCapturesStatusBarAppearance = .yes
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.action = { [weak self] in
            self?.viewModel.requestCategoryList()
        }
        self.present(controller, animated: .yes, completion: nil)
    }
}
