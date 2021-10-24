//
//  HomeGuide.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/21.
//

import UIKit

class HomeGuide: UIStackView {
    var quickAction: (() -> Void)? = nil
    
    private let pasteGuide: CorgiGuideView = .init(style: .fixed)
    private let quickGuide: CorgiGuideView = .init(style: .flexible)
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func show(quick content: String) {
        self.quickGuide.subheading = content
        
        guard self.quickGuide.isHidden else { return }
        
        self.quickGuide.alpha = .zero
        
        UIView.animate(withDuration: 0.25) {
            self.quickGuide.isHidden = .no
        } completion: { _ in
            self.quickGuide.isHidden = .no
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.125) {
            self.quickGuide.alpha = 1
        } completion: { _ in
            self.quickGuide.alpha = 1
        }
    }
}

private extension HomeGuide {
    func setup() {
        self.spacing = 8
        self.axis = .vertical
        self.setupPasteGuide(self.pasteGuide, inside: self)
        self.setupQuickGuide(self.quickGuide, inside: self)
    }
    
    func setupPasteGuide(_ view: CorgiGuideView, inside parent: UIStackView) {
        parent.addArrangedSubview(view)
        
        let guideConfiguration = GuideConfiguration.paste
        view.heading = guideConfiguration.title
        view.subheading = guideConfiguration.content
        view.iconImage = guideConfiguration.icon
    }
    
    func setupQuickGuide(_ view: CorgiGuideView, inside parent: UIStackView) {
        parent.addArrangedSubview(view)
        
        let guideConfiguration = GuideConfiguration.quick
        view.heading = guideConfiguration.title

        view.buttonAction = {
            CorgiPasteboard.shared.flush()
            view.hide()
        }
        
        view.viewAction = { [weak self] in
            CorgiPasteboard.shared.flush()
            view.hide()
            self?.quickAction?()
        }
    }
}

enum GuideConfiguration {
    case paste, quick
    
    var title: String {
        switch self {
        case .paste: return LocalizedString("home_copy_guide_title", comment: .empty)
        case .quick: return LocalizedString("home_paste_guide_title", comment: .empty)
        }
    }
    
    var content: String {
        switch self {
        case .paste: return LocalizedString("home_copy_guide_content", comment: .empty)
        case .quick: return .empty
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .paste: return .init(systemName: "doc.on.clipboard.fill")
        case .quick: return nil
        }
    }
}
