//
//  ViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit

class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable, message: "")
    required init?(coder: NSCoder) {
        fatalError()
    }
}
