//
//  AdditionViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/02.
//

import UIKit

class AdditionViewController: ViewController {
    private let viewModel: AdditionViewModel
    private let homeNavigator: HomeNavigator
    
    private let notificationCenter: NotificationCenter = .default
    
    init(viewModel: AdditionViewModel,
         homeNavigator: HomeNavigator) {
        self.viewModel = viewModel
        self.homeNavigator = homeNavigator
        
        super.init()
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func loadView() {
        self.view = AdditionView(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .corgi.background.base
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        KeyboardObserver.shared.subscribe(target: self) { event in
            switch event.type {
            case .willShow:
                UIView.animate(withDuration: 0.25) {
                    if event.beginFrame.equalTo(event.endFrame) {
                        return
                    }
                    
                    let origin = self.view.frame.origin
                    let newOrigin: CGPoint = .init(x: origin.x, y: origin.y - (event.beginFrame.origin.y - event.endFrame.origin.y))
                    self.view.frame.origin = newOrigin
                }
            case .willHide:
                UIView.animate(withDuration: 0.25) {
                    let origin = self.view.frame.origin
                    let newOrigin: CGPoint = .init(x: origin.x, y: origin.y + event.beginFrame.height)
                    self.view.frame.origin = newOrigin
                }
            default: break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isBeingDismissed {
            self.homeNavigator.navigateToHome()
        }
        
        KeyboardObserver.shared.unsubscribe(target: self)
    }
}

extension AdditionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DynamicHeightPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
