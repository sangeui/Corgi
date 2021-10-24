//
//  CorgiGuideView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/05.
//

import UIKit

enum GuideStyle {
    case fixed, flexible
}

class CorgiGuideView: View {
    var iconImage: UIImage? {
        get { self.iconImageView.image }
        set {
            self.iconImageView.image = newValue
            self.iconImageView.isHidden = newValue == nil
        }
    }
    
    var heading: String {
        get { self.verticalTextStackView.heading }
        set { self.verticalTextStackView.heading = newValue }
    }
    
    var subheading: String {
        get { self.verticalTextStackView.subheading }
        set { self.verticalTextStackView.subheading = newValue }
    }
    
    var insets: UIEdgeInsets {
        get {
            return .init(top: self.stackViewTop?.constant ?? .zero,
                         left: self.stackViewLeading?.constant ?? .zero,
                         bottom: self.stackViewBottom?.constant ?? .zero,
                         right: self.stackViewTrailing?.constant ?? .zero)
        }
        
        set {
            self.stackViewTop?.constant = newValue.top
            self.stackViewLeading?.constant = newValue.left
            self.stackViewBottom?.constant = newValue.bottom.minus
            self.stackViewTrailing?.constant = newValue.right.minus
        }
    }
    
    var textColor: UIColor {
        get { self.verticalTextStackView.textColor }
        set { self.verticalTextStackView.textColor = newValue }
    }
    
    var buttonTintColor: UIColor {
        get { self.button.tintColor }
        set { self.button.tintColor = newValue }
    }
    
    var buttonAction: (() -> Void)? = nil
    var viewAction: (() -> Void)? = nil
    
    private let horizontalStackView: UIStackView = .init()
    
    private let iconImageView: UIImageView = .init()
    private let verticalTextStackView: CorgiGuideVerticalTextStackView = .init()
    private let button: UIButton = .init()
    
    private var stackViewLeading: NSLayoutConstraint? = nil
    private var stackViewTrailing: NSLayoutConstraint? = nil
    private var stackViewTop: NSLayoutConstraint? = nil
    private var stackViewBottom: NSLayoutConstraint? = nil
    
    func setButtonImage(_ image: UIImage?, for state: UIControl.State) {
        self.button.setImage(image, for: state)
        self.button.isHidden = image == nil
    }
    
    func buttonImage(for state: UIControl.State) -> UIImage? {
        return self.button.image(for: state)
    }
    
    func show() {
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = .zero
        } completion: { success in
            if success.isNot { self.alpha = 1 }
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.125) {
            self.isHidden = .yes
        } completion: { success in
            if success.isNot {
                self.alpha = 1
                self.isHidden = false
            }
        }
    }
    
    init(style: GuideStyle) {
        super.init()
        self.setup()
        
        if style == .flexible {
            self.insets = .init(top: .corgi.spacing.padding,
                                left: .corgi.spacing.padding,
                                bottom: .corgi.spacing.padding,
                                right: .corgi.spacing.padding)
            self.backgroundColor = .corgi.main
            self.layer.cornerRadius = 10
            self.isHidden = true
            self.textColor = .white
            self.setButtonImage(.init(systemName: "xmark"), for: .normal)
        }
    }
    
    override init() {
        super.init()
        self.setup()
    }
}

private extension CorgiGuideView {
    @objc func viewDidTouch(recognizer: UIGestureRecognizer) {
        self.viewAction?()
    }
}

private extension CorgiGuideView {
    func setup() {
        self.setupTapGestureRecognizer(to: self)
        self.setupHorizontalStackView(self.horizontalStackView, under: self)
        self.setupIconImageView(self.iconImageView, under: self.horizontalStackView)
        self.setupVerticalStackView(self.verticalTextStackView, under: self.horizontalStackView)
        self.setupButton(self.button, under: self.horizontalStackView)
    }
    
    func setupTapGestureRecognizer(to view: UIView) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTouch(recognizer:)))
        recognizer.cancelsTouchesInView = .yes
        view.addGestureRecognizer(recognizer)
    }
    
    func setupHorizontalStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        self.stackViewLeading = stackView.leading.pin(equalTo: view.leading, constant: self.insets.left).activeAndReturn()
        self.stackViewTrailing = stackView.trailing.pin(equalTo: view.trailing, constant: self.insets.right.minus).activeAndReturn()
        self.stackViewTop = stackView.top.pin(equalTo: view.top, constant: self.insets.top).activeAndReturn()
        self.stackViewBottom = stackView.bottom.pin(equalTo: view.bottom, constant: self.insets.bottom.minus).activeAndReturn()
        stackView.alignment = .top
        stackView.spacing = .spacing
    }
    
    func setupIconImageView(_ imageView: UIImageView, under view: UIStackView) {
        view.addArrangedSubview(imageView)
        imageView.useAutoLayout
        imageView.width.pin(equalToConstant: .imageSize).active
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.isHidden = .yes
    }
    
    func setupVerticalStackView(_ stackView: UIStackView, under view: UIStackView) {
        view.addArrangedSubview(stackView)
        stackView.useAutoLayout
        stackView.height.pin(equalTo: view.height).active
    }
    
    func setupButton(_ button: UIButton, under view: UIStackView) {
        view.addArrangedSubview(button)
        button.useAutoLayout
        button.width.pin(equalToConstant: .buttonSize).active
        button.height.pin(equalTo: button.width).active
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.isHidden = .yes
        button.addTarget(self, action: #selector(self.buttonDidTouch(sender:)), for: .touchUpInside)
    }
}

private extension CorgiGuideView {
    @objc func buttonDidTouch(sender: Any) {
        self.buttonAction?()
    }
}

private extension CGFloat {
    static let spacing: Self = 20
    static let margin: Self = 2
    static let imageSize: Self = 15
    static let buttonSize: Self = 30
}

private extension UIEdgeInsets {
    static let `default`: Self = .init(top: 2, left: 2, bottom: 2, right: 2)
}
