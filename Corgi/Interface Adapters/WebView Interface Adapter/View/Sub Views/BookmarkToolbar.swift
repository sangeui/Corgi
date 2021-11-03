//
//  BookmarkToolbar.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/23.
//

import UIKit

class BookmarkToolbar: View {
    var onBackward: (() -> Void)? = nil
    var onForward: (() -> Void)? = nil
    var onRefresh: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil
    
    var backwardIsEnabled: Bool {
        get { self.backward.isEnabled }
        set { self.backward.isEnabled = newValue }
    }
    
    var forwardIsEnabled: Bool {
        get { self.forward.isEnabled }
        set { self.forward.isEnabled = newValue }
    }
    
    var refreshIsEnabled: Bool {
        get { self.refresh.isEnabled }
        set { self.refresh.isEnabled = newValue }
    }
    
    var shareIsEnabled: Bool {
        get { self.share.isEnabled }
        set { self.share.isEnabled = newValue }
    }
    
    private let backward: BookmarkWebviewButton = .init()
    private let forward: BookmarkWebviewButton = .init()
    private let refresh: BookmarkWebviewButton = .init()
    private let share: BookmarkWebviewButton = .init()
    
    private let stackView: UIStackView = .init()
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

private extension BookmarkToolbar {
    @objc func backwardDidTouch() {
        self.onBackward?()
    }
    
    @objc func forwardDidTouch() {
        self.onForward?()
    }
    
    @objc func refreshDidTouch() {
        self.onRefresh?()
    }
    
    @objc func shareDidTouch() {
        self.onShare?()
    }
}

private extension BookmarkToolbar {
    func setup() {
        self.setupStackView(self.stackView, inside: self)
        self.setupBackward(self.backward, inside: self.stackView)
        self.setupForward(self.forward, inside: self.stackView)
        self.setupRefresh(self.refresh, inside: self.stackView)
        self.setupShare(self.share, inside: self.stackView)
    }
    
    func setupStackView(_ view: UIStackView, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        view.leading.constraint(equalTo: parent.leading, constant: .corgi.spacing.padding).active
        view.trailing.constraint(equalTo: parent.trailing, constant: .corgi.spacing.padding.minus).active
        view.top.constraint(equalTo: parent.top, constant: .corgi.spacing.padding).active
        view.bottom.constraint(equalTo: parent.safearea.bottom, constant: .corgi.spacing.padding.minus).active
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = .corgi.spacing.margin
    }
    
    func setupBackward(_ button: BookmarkWebviewButton, inside view: UIStackView) {
        view.addArrangedSubview(button)
        button.setImage(.backButton, for: .normal)
        button.isEnabled = .no
        button.addTarget(self, action: #selector(self.backwardDidTouch), for: .touchUpInside)
    }
    
    func setupForward(_ button: BookmarkWebviewButton, inside view: UIStackView) {
        view.addArrangedSubview(button)
        button.setImage(.forwardButton, for: .normal)
        button.isEnabled = .no
        button.addTarget(self, action: #selector(self.forwardDidTouch), for: .touchUpInside)
    }
    
    func setupRefresh(_ button: BookmarkWebviewButton, inside view: UIStackView) {
        view.addArrangedSubview(button)
        button.setImage(.refreshButton, for: .normal)
        button.isEnabled = .no
        button.addTarget(self, action: #selector(self.refreshDidTouch), for: .touchUpInside)
    }
    
    func setupShare(_ button: BookmarkWebviewButton, inside view: UIStackView) {
        view.addArrangedSubview(button)
        button.setImage(.shareButton, for: .normal)
        button.isEnabled = .no
        button.addTarget(self, action: #selector(self.shareDidTouch), for: .touchUpInside)
    }
}

private extension UIImage {
    static let backButton: UIImage? = .init(systemName: "chevron.backward")
    static let forwardButton: UIImage? = .init(systemName: "chevron.forward")
    static let shareButton: UIImage? = .init(systemName: "square.and.arrow.up")
    static let refreshButton: UIImage? = .init(systemName: "arrow.clockwise")
}

