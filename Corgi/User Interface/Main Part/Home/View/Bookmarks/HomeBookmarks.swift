//
//  HomeBookmarks.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/21.
//

import UIKit

class HomeBookmarks: ContainerView {
    var onRefresh: (() -> Void)? = nil
    var onCommit: ((UITableViewCell.EditingStyle, IndexPath) -> Void)? = nil
    var onSelect: ((Bookmark) -> Void)? = nil
    
    var bookmarks: [Bookmark] = .empty {
        didSet {
            UIView.transition(with: self.tableView, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }, completion: nil)
        }
    }
    
    private let tableView: HomeTableView = .init()
    private let pasteboard: UIPasteboard = .general
    
    override init() {
        super.init()
        self.setup()
    }
    
    func toggleEditingMode() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.isEditing.toggle()
        }
    }
    
    func inject(bookmarks: [Bookmark]) {
        self.bookmarks = bookmarks
    }
}

extension HomeBookmarks: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmark = self.bookmarks[indexPath.row]
        guard let cell = tableView.dequeue(identifier: "Cell", for: indexPath) as? BookmarkTableViewCell else { return .init() }
        cell.urlString = bookmark.url.absoluteString.removingPercentEncoding
        cell.urlCategory = bookmark.group
        cell.urlDescription = bookmark.explanation
        cell.isHiddenCircleView = bookmark.isOpened
        
        if bookmark.url.favicon.isNotNil {
            cell.loadFavicon(at: bookmark.url.favicon!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return .yes
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.onCommit?(editingStyle, indexPath)
    }
}

extension HomeBookmarks: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelect?(self.bookmarks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return .init(identifier: nil, previewProvider: nil) { actions in
            let paste: UIAction = .paste { action in
                let bookmark = self.bookmarks[indexPath.row]
                self.pasteboard.url = bookmark.url
            }
            
            return .init(title: .empty, children: [paste])
        }
    }
}

private extension HomeBookmarks {
    func setup() {
        let shadowDecorator: ShadowViewDecorator = .init()
        self.decorate(with: shadowDecorator)
        self.setupTableView(self.tableView, inside: self)
    }
    
    func setupTableView(_ tableView: HomeTableView, inside parent: UIView) {
        parent.addSubview(tableView, autolayout: .yes)
        tableView.stretch(into: parent, padding: .corgi.spacing.padding)
        tableView.onRefresh = { [weak self] in self?.onRefresh?() }
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension URL {
    var favicon: Self? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: .no)
        let faviconURL = URL(string: "https://\(components?.host ?? "")/favicon.ico")
        return faviconURL
    }
}

private extension UIAction {
    static func paste(handler: @escaping UIActionHandler) -> UIAction {
        return .init(title: .pasteTitle, image: .paste, handler: handler)
    }
}

private extension UIImage {
    static let paste: UIImage? = .init(systemName: .pasteImageName)
}

private extension String {
    static let pasteImageName = "doc.on.clipboard.fill"
    static let pasteTitle = LocalizedString("home_paste_bookmark")
}
