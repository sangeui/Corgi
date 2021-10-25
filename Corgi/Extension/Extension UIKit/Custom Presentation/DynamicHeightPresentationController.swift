//
//  DynamicHeightPresentationController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/27.
//

import UIKit

class DynamicHeightPresentationController: UIPresentationController {
    private let dimmingView: View = .init()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else { return .zero }

        let inset: CGFloat = 16

        // Make sure to account for the safe area insets
        let safeAreaFrame = containerView.bounds
            .inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultHigh).height

        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += frame.size.height - targetHeight - inset
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.setupDimmingView(self.dimmingView)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.layer.cornerRadius = 12
        
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

private extension DynamicHeightPresentationController {
    @objc func dimmingViewDidTouched(recognizer: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: .yes, completion: nil)
    }
    
    func setupDimmingView(_ dimmingView: UIView) {
        dimmingView.useAutoLayout
        dimmingView.backgroundColor = .black.withAlphaComponent(0.5)
        dimmingView.alpha = .zero
        
        let recognizer: UITapGestureRecognizer = .init(target: self, action: #selector(self.dimmingViewDidTouched(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
}
