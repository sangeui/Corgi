//
//  HomeTableView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/20.
//

import UIKit

class HomeTableView: UITableView {
    static let cellReuseIdentifier = "Cell"
    
    var onRefresh: (() -> Void)? = nil
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension HomeTableView {
    @objc func refreshControlValueDidChange() {
        self.onRefresh?()
    }
}

private extension HomeTableView {
    func setup() {
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.tableFooterView = .init()
        self.register(BookmarkTableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        self.layer.cornerRadius = 20
        
        self.setupRefreshControl(.init())
    }
    
    func setupRefreshControl(_ refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueDidChange), for: .valueChanged)
    }
}
