//
//  NavigationController.swift
//  CorgiShare
//
//  Created by 서상의 on 2021/10/04.
//

import UIKit

@objc (NavigationController)
class NavigationController: UINavigationController {
    private let rootViewController = ViewController()
    
    init() {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
