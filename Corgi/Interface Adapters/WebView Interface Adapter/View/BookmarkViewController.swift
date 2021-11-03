//
//  BookmarkViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit
import Combine

class BookmarkViewController: ViewController, TitleImageViewSettable {
    
    private let viewModel: BookmarkViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        
        super.init()
        self.subscribe(to: self.viewModel.$view.eraseToAnyPublisher())
    }
    
    override func loadView() {
        self.view = BookmarkView(viewModel: self.viewModel,
                                 shareNavigator: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleImageView(with: .init(named: "Bookmark Title"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarHidden(.yes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavigationBarHidden(.no)
    }
}

private extension BookmarkViewController {
    func subscribe(to publisher: AnyPublisher<BookmarkNavigation<BookmarkViewType>, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigate(to: $0) }
            .store(in: &self.subscriptions)
    }
    
    func navigate(to navigation: BookmarkNavigation<BookmarkViewType>) {
        switch navigation {
        case .present(view: let viewType):
            self.navigate(to: viewType)
        case .presented(view: _): break
        }
    }
    
    func navigate(to viewType: BookmarkViewType) {
        var viewController: UIViewController? = nil
        
        switch viewType {
        case .bookmark: break
        case .share(let url):
            viewController = self.prepareShareActivityController(url: url)
        }
        
        guard let viewController = viewController else { return }
        self.present(viewController, animated: .yes)
    }
    
    func prepareShareActivityController(url: URL) -> UIActivityViewController {
        return .init(activityItems: [url], applicationActivities: nil)
    }
}

private extension BookmarkViewController {
    func setNavigationBarHidden(_ isHidden: Bool) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: .yes)
    }
}
