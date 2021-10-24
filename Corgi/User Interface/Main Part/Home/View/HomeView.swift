//
//  HomeView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/05.
//

import UIKit
import Combine

class HomeView: View {
    private let viewModel: HomeViewModel
    
    // User Interface
    private let caption: CaptionLabel = .init()
    private let message: DisabledMessageLabel = .init()
    private let homeBookmarks: HomeBookmarks = .init()
    private let homeGuide: HomeGuide = .init()
    private let homeToolbar: HomeToolbar = .init()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        self.setup()
        self.subscribe(to: self.viewModel.$bookmarkList.eraseToAnyPublisher())
        self.subscribeURL(to: self.viewModel.$url.eraseToAnyPublisher())
    }
}

extension HomeView {
    func subscribeURL(to publisher: AnyPublisher<URL?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] url in
                guard let self = self else { return }
                self.homeGuide.show(quick: url.absoluteString)
            }.store(in: &self.subscriptions)
    }
    
    func subscribe(to publisher: AnyPublisher<[Bookmark], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                guard let self = self else { return }
                self.message.isHidden = self.viewModel.bookmarkList.isEmpty.isNot
                self.caption.isHidden = self.viewModel.bookmarkList.isEmpty
                
                self.homeBookmarks.inject(bookmarks: bookmarks)
            }
            .store(in: &self.subscriptions)
    }
}

private extension HomeView {
    @objc func removeButtonDidTouched() {
        self.homeBookmarks.toggleEditingMode()
    }
}

private extension HomeView {
    func setup() {
        self.setupHomeToolbar(self.homeToolbar, inside: self)
        self.setupHomeGuide(self.homeGuide, inside: self, above: self.homeToolbar)
        self.setupCaptionLabel(self.caption, inside: self)
        self.setupHomeBookmarks(self.homeBookmarks, inside: self)
        self.setupDisabledMessageLabel(self.message, under: self.homeBookmarks)
    }
    
    func setupCaptionLabel(_ label: CaptionLabel, inside view: UIView) {
        view.addSubview(label, autolayout: .yes)
        
        label.leading.pin(equalTo: view.leading, constant: .corgi.spacing.margin).active
        label.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.margin.minus).active
        label.top.pin(equalTo: view.safearea.top, constant: .corgi.spacing.margin).active
        
        label.caption(LocalizedString("home_caption_guide"))
    }
    
    func setupHomeBookmarks(_ view: HomeBookmarks, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        
        view.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        view.top.pin(equalTo: self.caption.bottom, constant: 2).active
        view.bottom.pin(equalTo: self.homeGuide.top, constant: .corgi.spacing.margin.minus).active
        
        view.onSelect = { [weak self] in self?.viewModel.showBookmarkView(with: $0) }
        view.onRefresh = { [weak self] in self?.viewModel.updateBookmarkList() }
        view.onCommit = { [weak self] (editingStyle, indexPath) in
            if editingStyle == .delete {
                let _ = self?.viewModel.removeBookmark(given: indexPath.row)
            }
        }
    }
    
    func setupDisabledMessageLabel(_ label: DisabledMessageLabel, under view: UIView) {
        view.addSubview(label, autolayout: .yes)
        label.leading.pin(equalTo: view.leading, constant: .corgi.spacing.margin).active
        label.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.margin.minus).active
        label.centery.pin(equalTo: view.centery).active
        label.message(LocalizedString("home_bookmarks_empty"))
    }
    
    func setupHomeToolbar(_ view: HomeToolbar, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        view.leading.pin(equalTo: self.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: self.trailing, constant: .corgi.spacing.margin.minus).active
        view.bottom.pin(equalTo: self.safearea.bottom, constant: .corgi.spacing.margin.minus).active
        view.height.pin(equalToConstant: .corgi.size.height(multiplier: 2)).active
        
        view.add = { [weak self] in self?.viewModel.showAdditionView() }
        view.remove = { [weak self] in self?.removeButtonDidTouched() }
        view.groups = { [weak self] in self?.viewModel.showCategoryView() }
    }

    func setupHomeGuide(_ view: HomeGuide, inside parent: UIView, above sibling: UIView) {
        parent.addSubview(view, autolayout: .yes)
        
        view.bottom.pin(equalTo: sibling.top, constant: .corgi.spacing.margin.minus).active
        view.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        
        view.quickAction = { [weak self] in
            guard let url = self?.viewModel.url else { return }
            let bookmark: UnfinishedBookmark = .init(addressString: url.absoluteString, description: nil, category: nil)
            self?.viewModel.showAdditionViewWithBookmark(bookmark)
        }
    }
}
