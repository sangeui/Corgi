//
//  WebTitleView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/23.
//

import UIKit

class WebTitleView: UIStackView {
    var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var attributedTitle: NSAttributedString? {
        get { return self.titleLabel.attributedText }
        set { self.titleLabel.attributedText = newValue }
    }
    
    var subTitle: String? {
        get { return self.urlLabel.text }
        set { self.urlLabel.text = newValue }
    }
    
    var attributedSubTitle: NSAttributedString? {
        get { return self.urlLabel.attributedText }
        set { self.urlLabel.attributedText = newValue }
    }
    
    private let titleLabel: UILabel = .init()
    private let urlLabel: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func animate(block: () -> Void) {
        self.alpha = .zero
        
        block()
        
        UIView.animate(withDuration: 0.25, delay: .zero, options: [], animations: {
            self.isHidden = .no
        }, completion: { _ in

        })
        
        UIView.animate(withDuration: 0.25, delay: 0.125, options: [], animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}

private extension WebTitleView {
    func setup() {
        self.axis = .vertical
        self.setupTitleLabel(self.titleLabel, inside: self)
        self.setupURLlabel(self.urlLabel, inside: self)
    }
    
    func setupTitleLabel(_ label: UILabel, inside parent: UIStackView) {
        parent.addArrangedSubview(label)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .corgi.subTitle4
    }
    
    func setupURLlabel(_ label: UILabel, inside parent: UIStackView) {
        parent.addArrangedSubview(label)
        label.textAlignment = .center
        label.textColor = .corgi.text.secondary
        label.font = .corgi.caption1
    }
}
