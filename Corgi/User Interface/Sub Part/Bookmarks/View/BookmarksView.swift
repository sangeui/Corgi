//
//  BookmarksView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/08.
//

import UIKit
import Combine

class BookmarksView: View {
    private let pasteboard: UIPasteboard = .general
    weak var delegate: TestDelegate? = nil
    
    private let viewModel: BookmarksViewModel
    
    private let informatinoView: View = .init()
    private let titleLabel: UILabel = .init()
    
    private let bookmarksTableView: UITableView = .init()
    private let stackView: UIStackView = .init()
    private let button: BookmarksRoundButton = .init()
    private let emptyLabel: DisabledMessageLabel = .init()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: BookmarksViewModel) {
        self.viewModel = viewModel
        super.init()
        self.setup()
        self.subscribe(to: self.viewModel.$bookmarks.eraseToAnyPublisher())
        self.subscribe(to: self.viewModel.$group.eraseToAnyPublisher())
    }
}

extension BookmarksView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.navigate(to: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return .init(identifier: indexPath as NSCopying, previewProvider: nil) { actions in
            let paste: UIAction = .paste { action in
                let bookmark = self.viewModel.bookmarks[indexPath.row]
                self.pasteboard.url = bookmark.url
            }
            
            return .init(title: "", children: [paste])
        }
    }
}

extension BookmarksView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmark = self.viewModel.bookmarks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BookmarkTableViewCell ?? .init()
        cell.urlString = bookmark.url.absoluteString
        cell.urlDescription = bookmark.explanation
        cell.isHiddenCircleView = bookmark.isOpened
        
        let url = bookmark.url
        let components = URLComponents(url: url, resolvingAgainstBaseURL: .no)
        
        let faviconURLstring = "https://\(components?.host ?? "")/favicon.ico"
        
        if let url = URL(string: faviconURLstring) {
            cell.loadFavicon(at: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return .yes
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if self.viewModel.removeBookmark(given: indexPath.row) {
        }
    }
}

private extension BookmarksView {
    func subscribe(to publisher: AnyPublisher<[Bookmark], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                self?.emptyLabel.isHidden = bookmarks.isEmpty.isNot
                self?.bookmarksTableView.reloadData()
            }
            .store(in: &self.subscriptions)
    }
    
    func subscribe(to publisher: AnyPublisher<Group, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] group in
                self?.viewModel.requestBookmarkList()
                self?.titleLabel.text = group.name
            }
            .store(in: &self.subscriptions)
    }
}

private extension BookmarksView {
    var fixedHeight: CGFloat { return 150.0 }
    
    func setup() {
        self.backgroundColor = .systemBackground
        self.setupInformationView(self.informatinoView, inside: self)
        self.setupTitleLabel(self.titleLabel, inside: self.informatinoView)
        self.setupStackView(self.stackView, inside: self)
        self.setupButton(self.button, inside: self.stackView)
        self.setupTableView(self.bookmarksTableView, inside: self, between: (self.stackView, self.informatinoView))
        self.setupEmptyMessageLabel(self.emptyLabel, under: self)
    }
    
    func setupInformationView(_ view: UIView, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        
        view.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        view.top.pin(equalTo: parent.safearea.top, constant: .zero).active
        view.height.pin(greaterThanOrEqualToConstant: 44).active
        
        view.backgroundColor = .systemBackground
    }
    
    func setupTitleLabel(_ label: UILabel, inside parent: UIView) {
        parent.addSubview(label, autolayout: .yes)
        label.leading.pin(equalTo: parent.leading).active
        label.trailing.pin(equalTo: parent.trailing).active
        label.top.pin(equalTo: parent.top).active
        label.bottom.pin(equalTo: parent.bottom).active
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = .corgi.subTitle4
        label.text = LocalizedString("bookmarks_group_name")
    }
        
    func setupTableView(_ tableView: UITableView, inside parent: UIView, between: (above: UIView, below: UIView)) {
        parent.addSubview(tableView, autolayout: .yes)
        
        tableView.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        tableView.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        tableView.top.pin(equalTo: between.below.bottom, constant: .corgi.spacing.margin.minus).active
        tableView.bottom.pin(equalTo: between.above.safearea.top, constant: -4).active
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = .corgi.spacing.margin
        tableView.verticalScrollIndicatorInsets.top = .corgi.spacing.margin
        tableView.setContentOffset(.init(x: 0, y: .corgi.spacing.margin.minus), animated: .no)
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        parent.bringSubviewToFront(between.below)
    }
    
    func setupStackView(_ stackView: UIStackView, inside view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: .corgi.spacing.margin).active
        stackView.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.margin.minus).active
        stackView.bottom.pin(equalTo: view.safearea.bottom).active
        
        stackView.axis = .vertical
        stackView.alignment = .trailing
    }
    
    func setupButton(_ button: BookmarksRoundButton, inside parent: UIStackView) {
        parent.addArrangedSubview(button)
        button.addAction(.init(handler: { _ in
            self.delegate?.openTest()
        }), for: .touchUpInside)
        button.title = LocalizedString("bookmarks_other_group")
        button.image = .init(systemName: "arrow.right.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small))
    }
    
    func setupEmptyMessageLabel(_ label: DisabledMessageLabel, under view: UIView) {
        view.addSubview(label, autolayout: .yes)
        label.leading.pin(equalTo: view.leading, constant: .corgi.spacing.margin).active
        label.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.margin.minus).active
        label.centery.pin(equalTo: view.centery).active
        label.message(LocalizedString("bookmarks_empty_bookmarks"))
    }
}

protocol TestDelegate: AnyObject {
    func openTest()
}

private extension String {
    static let pasteImageName = "doc.on.clipboard.fill"
    static let pasteTitle = LocalizedString("bookmarks_copy_name")
}

private extension UIImage {
    static let paste: UIImage? = .init(systemName: .pasteImageName)
}

private extension UIAction {
    static func paste(handler: @escaping UIActionHandler) -> UIAction {
        return .init(title: .pasteTitle, image: .paste, handler: handler)
    }
}
