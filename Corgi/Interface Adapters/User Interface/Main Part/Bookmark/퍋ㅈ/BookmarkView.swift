//
//  BookmarkView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/17.
//

import UIKit
import WebKit

class BookmarkView: View {
    private let viewModel: BookmarkViewModel
    private let shareNavigator: ShareNavigator
    
    private let topView: View = .init()
    private let webView: WebView = .init()
    private let toolbar: BookmarkToolbar = .init()
    private let stackView: UIStackView = .init()
    
    private let webTitleView: WebTitleView = .init()
    private let expandButton: UIButton = .init(image: (.pullDown))
    private let bookmarkInformationView: View = .init()
    private let bookmarkInformationTableView: TableView = .init()
    
    init(viewModel: BookmarkViewModel,
         shareNavigator: ShareNavigator) {
        self.viewModel = viewModel
        self.shareNavigator = shareNavigator
        super.init()
        
        self.setup()
        
        if let urlReqeust = self.viewModel.urlRequest() {
            self.webView.load(urlReqeust)
        }
        
        self.bookmarkInformationView.isHidden = .yes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowDecorator: ShadowViewDecorator = .init()
        self.topView.decorate(with: shadowDecorator)
    }
}

extension BookmarkView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellIdentifier, for: indexPath) as? BookmarkDescriptionTableViewCell ?? .init()
        cell.heading = indexPath.section.headerTitle
        
        switch indexPath.section {
        case 0: cell.subheading = self.viewModel.bookmarkCategory()
        case 1: cell.subheading = self.viewModel.bookmarkURLstring()
        case 2: cell.subheading = self.viewModel.bookmarkDescription()
        default: break
        }
        
        return cell
    }
}

extension BookmarkView {
    private func createdWebSubTitle(url: URL?) -> NSAttributedString? {
        guard let urlComponents: URLComponents = .init(string: url?.absoluteString ?? .empty) else { return nil }
        
        guard urlComponents.scheme == .scheme else {
            return .init(string: urlComponents.host ?? .empty)
        }
        
        return self.createLockPrefixedString(urlComponents.host ?? .empty)
    }
    
    private func createLockPrefixedString(_ string: String) -> NSAttributedString? {
        guard let lockImage: UIImage = .lock?.withTintColor(.lightGray) else { return nil }
        
        let attachment: NSTextAttachment = .init(image: lockImage)
        let text: NSMutableAttributedString = .init(string: string)
        text.insert(.init(attachment: attachment), at: .zero)
        
        return text
    }
}

private extension BookmarkView {
    @objc func webViewBackButtonDidTouched() {
        guard self.webView.canGoBack else { return }
        
        self.webView.goBack()
    }
    
    @objc func webViewForwardButtonDidTouched() {
        guard self.webView.canGoForward else { return }
        
        self.webView.goForward()
    }
    
    @objc func webViewShareButtonDidTouched() {
        guard let url = self.webView.url else { return }
        
        self.shareNavigator.navigateToShare(url: url)
    }
    
    @objc func webViewRefreshButtonDidTouched() {
        self.webView.reload()
    }
    
    @objc func expandButtonDidTouched(sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        button.isSelected.toggle()
        
        UIView.animate(withDuration: 0.25) {
            self.bookmarkInformationView.isHidden = button.isSelected.isNot
        }
    }
}

private extension BookmarkView {
    func setup() {
        self.backgroundColor = .systemBackground
        self.setupTopView(self.topView)
        self.setupStackView(self.stackView, under: self.topView)
        self.setupWebTitleView(self.webTitleView, under: self.stackView)
        self.setupBookmarkInformationView(self.bookmarkInformationView, under: self.stackView)
        self.setupExpandButton(self.expandButton, under: self.stackView)
        
        self.setupToolbar(self.toolbar, under: self)
        self.setupWebView(self.webView)
        self.setupTableView(self.bookmarkInformationTableView, under: self.bookmarkInformationView)
    }
    
    func setupTopView(_ view: View) {
        self.addSubview(view, autolayout: .yes)
        
        view.leading.pin(equalTo: self.leading).active
        view.trailing.pin(equalTo: self.trailing).active
        view.top.pin(equalTo: self.top).active
        
        let heightConstraint = view.height.pin(equalToConstant: .zero)
        heightConstraint.priority = .defaultLow
        heightConstraint.active
        
        view.backgroundColor = .corgi.background.base
        view.layer.zPosition = 1
        
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init(corner: [.leftBottom, .rightBottom])
        view.decorate(with: cornerRadiusDecorator)
    }
    
    func setupToolbar(_ toolbar: BookmarkToolbar, under parent: UIView) {
        parent.addSubview(toolbar, autolayout: .yes)
        toolbar.leading.pin(equalTo: parent.leading).active
        toolbar.trailing.pin(equalTo: parent.trailing).active
        toolbar.bottom.pin(equalTo: parent.bottom).active
        
        let heightConstraint = toolbar.height.pin(equalToConstant: .zero)
        heightConstraint.priority = .defaultLow
        heightConstraint.active
        
        toolbar.backgroundColor = .corgi.background.base
        
        let borderDecorator: BorderDecorator = .init()
        toolbar.decorate(with: borderDecorator)
        
        toolbar.onBackward = { [weak self] in
            self?.webView.goBack()
        }
        
        toolbar.onForward = { [weak self] in
            self?.webView.goForward()
        }
        
        toolbar.onRefresh = { [weak self] in
            self?.webView.reload()
        }
        
        toolbar.onShare = { [weak self] in
            guard let self = self,
                  let url = self.webView.url else { return }
            
            self.shareNavigator.navigateToShare(url: url)
        }
    }
    
    func setupWebView(_ view: WebView) {
        self.addSubview(view, autolayout: .yes)
        view.leading.pin(equalTo: self.leading).active
        view.trailing.pin(equalTo: self.trailing).active
        view.top.pin(equalTo: self.topView.bottom).active
        view.bottom.pin(equalTo: self.toolbar.top).active
        
        view.onLoading = { [weak self] isLoading in
            self?.toolbar.refreshIsEnabled = isLoading.isNot
        }
        
        view.onFinish = { [weak self] returnedWebView in
            guard let self = self else { return }
            
            self.webTitleView.animate {
                self.webTitleView.title = returnedWebView.title
                self.webTitleView.attributedSubTitle = self.createdWebSubTitle(url: returnedWebView.url)
            }
            
            self.toolbar.backwardIsEnabled = returnedWebView.canGoBack
            self.toolbar.forwardIsEnabled = returnedWebView.canGoForward
            self.toolbar.shareIsEnabled = returnedWebView.url != nil
        }
    }
    
    func setupStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: .corgi.spacing.padding).active
        stackView.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.padding.minus).active
        stackView.top.pin(equalTo: view.safearea.top, constant: .corgi.spacing.padding).active
        stackView.bottom.pin(equalTo: view.bottom, constant: .corgi.spacing.padding.minus).active
        
        stackView.axis = .vertical
    }
    
    func setupWebTitleView(_ view: WebTitleView, under parent: UIStackView) {
        parent.addArrangedSubview(view)
    }
    
    func setupExpandButton(_ button: UIButton, under stackView: UIStackView) {
        stackView.addArrangedSubview(button)
        
        button.tintColor = .corgi.text.primary
        button.setImage(.pullDown, for: .normal)
        button.setImage(.pullUp, for: .selected)
        button.addTarget(self, action: #selector(self.expandButtonDidTouched(sender:)), for: .touchUpInside)
    }
    
    func setupBookmarkInformationView(_ view: UIView, under stackView: UIStackView) {
        stackView.addArrangedSubview(view)
    }
    
    func setupTableView(_ tableView: UITableView, under view: UIView) {
        view.addSubview(tableView, autolayout: .yes)
        tableView.stretch(into: view, padding: .corgi.spacing.padding)
        
        tableView.isScrollEnabled = .no
        tableView.tableFooterView = .init()
        tableView.dataSource = self
        
        tableView.register(BookmarkDescriptionTableViewCell.self, forCellReuseIdentifier: .cellIdentifier)
        
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        tableView.decorate(with: cornerRadiusDecorator)
        
        tableView.backgroundColor = .corgi.background.grouped
        tableView.separatorStyle = .none
    }
}

private extension String {
    static let cellIdentifier: String = "Cell"
    static let scheme: String = "https"
}

private extension Int {
    var headerTitle: String {
        switch self {
        case 0: return LocalizedString("bookmark_title_group")
        case 1: return LocalizedString("bookmark_title_url")
        case 2: return LocalizedString("bookmark_title_description")
        default: return ""
        }
    }
}

private extension UIImage {
    static let lock: UIImage? = .init(systemName: "lock.fill")
    static let pullDown: UIImage? = .init(systemName: "chevron.compact.down")
    static let pullUp: UIImage? = .init(systemName: "chevron.compact.up")
}

class BookmarkWebviewButton: UIButton {
    override var isEnabled: Bool {
        didSet { self.enabledStateDidUpdate(to: isEnabled) }
    }
    
    init() {
        super.init(frame: .zero)
        self.tintColor = .corgi.main
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension BookmarkWebviewButton {
    func enabledStateDidUpdate(to isEnabled: Bool) {
        if isEnabled {
            self.tintColor = .corgi.main
        } else {
            self.tintColor  = .gray
        }
    }
}
