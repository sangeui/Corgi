//
//  TableView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/07.
//

import UIKit

class TableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        return .init(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
}
