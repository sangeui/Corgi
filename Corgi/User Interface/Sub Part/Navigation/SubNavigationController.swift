//
//  BookmarksMainNavigationController.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/15.
//

import UIKit
import Combine

class SubNavigationController: NavigationController {
    var action: (() -> Void)? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: BookmarksMainViewModel
    private let bookmarks: (Group) -> BookmarksViewController
    private let bookmark: (Bookmark) -> BookmarkViewController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: BookmarksMainViewModel,
         bookmarks: @escaping (Group) -> BookmarksViewController,
         bookmark: @escaping (Bookmark) -> BookmarkViewController) {
        self.viewModel = viewModel
        self.bookmarks = bookmarks
        self.bookmark = bookmark
        super.init()
        
        self.view.backgroundColor = .systemBackground
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.backgroundImage = .init()
        appearance.shadowImage = .init()
        appearance.shadowColor = .clear
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationBar.tintColor = .label
        
        self.subscribe(to: self.viewModel.$view.eraseToAnyPublisher())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.action?()
    }
}

extension SubNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let navigatedView = self.navigatedView(viewController: viewController) else { return }
        self.viewModel.viewDidNavigate(to: navigatedView)
    }
    
    private func navigatedView(viewController: UIViewController) -> BookmarksMainViewType? {
        switch viewController {
        case is BookmarksViewController: return .bookmarks()
        case is BookmarkViewController: return .bookmark()
        default: return nil
        }
    }
}

private extension SubNavigationController {
    func subscribe(to publisher: AnyPublisher<BookmarksMainNavigation<BookmarksMainViewType>, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigate(to: $0) }
            .store(in: &self.subscriptions)
    }
    
    func navigate(to navigation: BookmarksMainNavigation<BookmarksMainViewType>) {
        switch navigation {
        case .present(view: let viewType): self.presentViewType(viewType)
        case .presented(view: _): break
        }
    }
    
    func presentViewType(_ viewType: BookmarksMainViewType) {
        switch viewType {
        case .bookmarks(let group):
            guard let group = group else { return }
            self.pushViewController(self.bookmarks(group), animated: .no)
        case .bookmark(let bookmark):
            guard let bookmark = bookmark else { return }
            let controller = self.bookmark(bookmark)
            self.pushViewController(controller, animated: .yes)
        }
    }
}

enum BookmarksMainNavigation<ViewType>: Equatable where ViewType: Equatable {
    case present(view: ViewType)
    case presented(view: ViewType)
}

enum BookmarksMainViewType: Equatable {
    case bookmarks(Group? = nil)
    case bookmark(Bookmark? = nil)
}

class BookmarksMainViewModel {
    @Published public private(set) var view: BookmarksMainNavigation<BookmarksMainViewType> = .presented(view: .bookmarks())
    
    func viewDidNavigate(to view: BookmarksMainViewType) {
        self.view = .presented(view: view)
    }
}

extension BookmarksMainViewModel: BookmarkNavigator {
    func navigateToBookmark(bookmark: Bookmark) {
        self.view = .present(view: .bookmark(bookmark))
    }
}

