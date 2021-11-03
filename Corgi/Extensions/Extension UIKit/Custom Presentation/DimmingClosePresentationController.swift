//
//  DimmingClosePresentationController.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/15.
//

import UIKit

class DimmingClosePresentationController: UIPresentationController {
    private let dimmingView: DimmingCloseView = .init()
    private let stackView: UIStackView = .init()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        // Make sure to account for the safe area insets
        let safeAreaFrame = containerView.bounds

        let targetWidth = safeAreaFrame.width
        let targetHeight = safeAreaFrame.height - containerView.safeAreaInsets.top - 44

        var frame = safeAreaFrame
        frame.origin.y += frame.size.height - targetHeight
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.setupDimmingView(self.dimmingView)
        self.dimmingView.action = { [weak self] in
            self?.presentingViewController.dismiss(animated: .yes, completion: nil)
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        self.presentedView?.layer.cornerRadius = 12
        
        self.containerView?.insertSubview(dimmingView, at: .zero)
        
        self.dimmingView.frame = self.containerView?.bounds ?? .zero
        
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            self.dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            self.dimmingView.alpha = .zero
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = .zero
        }, completion: nil)
    }
}

private extension DimmingClosePresentationController {
    @objc func dimmingViewDidTouched(recognizer: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: .yes, completion: nil)
    }
    
    func setupDimmingView(_ view: UIView) {
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.alpha = .zero
    }
}

class DimmingCloseView: View {
    var action: (() -> ())? = nil
    
    private let stackView: UIStackView = .init()
    private let closeButton: UIButton = .init()
    
    override init() {
        super.init()
        self.setup()
    }
}

private extension DimmingCloseView {
    @objc private func closeButtonDidTouch() {
        self.action?()
    }
    
    func setup() {
        self.setupButtonStackView(self.stackView, inside: self)
        self.setupCloseButton(self.closeButton, inside: self.stackView)
    }
    
    func setupButtonStackView(_ stackView: UIStackView, inside parent: UIView) {
        parent.addSubview(stackView, autolayout: .yes)
        stackView.leading.pin(equalTo: parent.leading, constant: 20).active
        stackView.trailing.pin(equalTo: parent.trailing, constant: -20).active
        stackView.top.pin(equalTo: parent.safearea.top).active
        stackView.height.pin(equalToConstant: 44).active
        stackView.alignment = .trailing
        stackView.axis = .vertical
    }
    
    func setupCloseButton(_ button: UIButton, inside parent: UIStackView) {
        parent.addArrangedSubview(button)
        button.useAutoLayout
        button.setImage(.init(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.closeButtonDidTouch), for: .touchUpInside)
    }
}
