//
//  HomeViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit
import Combine
import OSLog

protocol TitleImageViewSettable {}
extension TitleImageViewSettable where Self: UIViewController {
    func titleImageView(with image: UIImage?) {
        let imageView: UIImageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .label
        self.navigationItem.titleView = imageView
    }
}

class HomeViewController: ViewController, TitleImageViewSettable {
    private let viewModel: HomeViewModel
    private let additionViewController: (UnfinishedBookmark?) -> AdditionViewController
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(viewModel: HomeViewModel,
         addition: @escaping (UnfinishedBookmark?) -> AdditionViewController) {
        self.viewModel = viewModel
        self.additionViewController = addition
        
        super.init()
    }
    
    override func loadView() {
        self.view = HomeView(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindToAdditionViewState()
        self.titleImageView(with: .init(named: "Corgi Title"))
        
        let symbolConfiguration: UIImage.SymbolConfiguration = .init(pointSize: 12)
        let image: UIImage? = .init(systemName: "gearshape", withConfiguration: symbolConfiguration)
        
        let barButtonItem: UIBarButtonItem = .init()
        barButtonItem.image = image
        barButtonItem.target = self.viewModel
        barButtonItem.action = #selector(self.viewModel.showSettingsView)
        barButtonItem.tintColor = .label
        
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private let pasteBoard = CorgiPasteboard.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.updateBookmarkList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground(notification:))
                                               , name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

private extension HomeViewController {
    @objc func willEnterForeground(notification: Notification) {
        if pasteBoard.check(),
           let url = pasteBoard.paste() {
            self.viewModel.pasteURL(url)
        }
    }
}

private extension HomeViewController {
    func presentedViewControllerDidDismiss() {
        self.viewModel.updateBookmarkList()
    }
}

private extension HomeViewController {
    func bindToAdditionViewState() {
        self.viewModel
            .$showingAdditionView
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] viewState in
                guard let self = self else { return }
                
                self.update(additionViewState: viewState)
            }
            .store(in: &subscriptions)
    }
    
    func update(additionViewState: HomeViewType) {
        switch additionViewState {
        case .home:
            if let _ = self.presentedViewController {
                self.dismiss(animated: true, completion: {
                    self.presentedViewControllerDidDismiss()
                })
            }
        case .addition(let bookmark):
            if self.presentedViewController == nil {
                let controller = self.additionViewController(bookmark)
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
