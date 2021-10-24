//
//  MainViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit
import Combine

class MainNavigationController: NavigationController {
    private let viewModel: MainViewModel
    
    private let homeViewController: HomeViewController
    private let categoryViewController: () -> GroupsViewController
    private let bookmarkViewController: (Bookmark) -> BookmarkViewController
    private let settingsViewController: () -> SettingsViewController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel,
         home: HomeViewController,
         category: @escaping () -> GroupsViewController,
         bookmark: @escaping (Bookmark) -> BookmarkViewController,
         settings: @escaping () -> SettingsViewController) {
        self.viewModel = viewModel
        self.homeViewController = home
        self.categoryViewController = category
        self.bookmarkViewController = bookmark
        self.settingsViewController = settings
        
        super.init()
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.subscribe(to: self.viewModel.$view1.eraseToAnyPublisher())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

private extension MainNavigationController {
    func subscribe(to publisher: AnyPublisher<Navigation<MainViewType>, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigate(to: $0) }
            .store(in: &subscriptions)
    }
    
    func navigate(to navigation: Navigation<MainViewType>) {
        switch navigation {
        case .present(view: let mainViewType):
            self.navigate(to: mainViewType)
        case .presented(view: _): break
        }
    }
    
    func navigate(to viewType: MainViewType) {
        let viewController: UIViewController
        var animated: Bool = .yes
        
        switch viewType {
        case .home: viewController = self.homeViewController; animated = .no
        case .category: viewController = self.categoryViewController()
        case .bookmark(let bookmark): viewController = self.bookmarkViewController(bookmark)
        case .settings: viewController = self.settingsViewController()
        default: fatalError()
        }
        
        if self.presentedViewController != nil {
            self.dismiss(animated: true) {
                self.pushViewController(viewController, animated: animated)
            }
        } else {
            self.pushViewController(viewController, animated: animated)
        }
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let navigatedView = self.navigatedView(viewController: viewController) else { return }
        self.viewModel.viewDidNavigate(to: navigatedView)
    }
    
    private func navigatedView(viewController: UIViewController) -> MainViewType? {
        switch viewController {
        case is HomeViewController: return .home
        case is GroupsViewController: return .category
        case is BookmarkViewController: return .bookmarkWithoutBookmark
        default: return nil
        }
    }
}

private extension MainNavigationController {
    func setup() {
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
    }
}
