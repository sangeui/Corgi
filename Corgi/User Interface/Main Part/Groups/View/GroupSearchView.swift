//
//  CategorySearchView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/03.
//

import UIKit

class GroupSearchView: View {
    override var isFirstResponder: Bool { return self.searchField.isFirstResponder }
    
    var textDidChange: ((String) -> Void)? = nil
    
    private let stackView: UIStackView = .init()
    private let searchIcon: UIImageView = .init()
    private let searchField: UITextField = .init()
    
    private var visualEffectView: UIVisualEffectView?
    
    override init() {
        super.init()
        self.setup()
    }
    
    func highlight() {
        self.backgroundColor = .corgi.main
        self.searchIcon.tintColor = .white
        self.searchField.tintColor = .white
        self.searchField.textColor = .white
        self.searchField.attributedPlaceholder = .highlight
    }
    
    func dehighlight() {
        self.backgroundColor = .corgi.background.grouped
        self.searchIcon.tintColor = .corgi.main
        self.searchField.tintColor = .corgi.main
        self.searchField.textColor = .corgi.main
        self.searchField.attributedPlaceholder = .dehighlight
        
        self.visualEffectView?.removeFromSuperview()
    }
}

extension GroupSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return .yes
    }
}

private extension GroupSearchView {
    @objc func textFieldDidChange(textField: UITextField) {
        self.textDidChange?(textField.text ?? "")
    }
}

private extension GroupSearchView {
    func setup() {
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        self.decorate(with: cornerRadiusDecorator)
        let shadowDecorator: ShadowViewDecorator = .init()
        self.decorate(with: shadowDecorator)
        self.backgroundColor = .corgi.background.grouped
        
        self.setupStackView(self.stackView, under: self)
        self.setupImageView(self.searchIcon, under: self.stackView)
        self.setupTextField(self.searchField, under: self.stackView)
    }
    
    func setupStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: .corgi.spacing.margin).active
        stackView.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.margin.minus).active
        stackView.top.pin(equalTo: view.top).active
        stackView.bottom.pin(equalTo: view.bottom).active
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
    }
    
    func setupImageView(_ imageView: UIImageView, under stackView: UIStackView) {
        stackView.addArrangedSubview(imageView)
        
        imageView.image = .init(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFit
        imageView.useAutoLayout
        imageView.width.pin(equalToConstant: 20).active
        imageView.tintColor = .systemOrange
    }
    
    func setupTextField(_ textField: UITextField, under stackView: UIStackView) {
        stackView.addArrangedSubview(textField)
        
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.textColor = .white
        textField.font = .corgi.subtitle3
        textField.tintColor = .corgi.main
        textField.attributedPlaceholder = .dehighlight
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
}

private extension NSAttributedString {
    static let highlight: NSAttributedString = .init(string: LocalizedString("groups_search"),
                                                     attributes: .attributes(color: .white,
                                                                             font: .corgi.subtitle3))
    static let dehighlight: NSAttributedString = .init(string: LocalizedString("groups_search"),
                                                       attributes: .attributes(color: .corgi.main,
                                                                               font: .corgi.subtitle3))
}

private extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    static func attributes(color: UIColor, font: UIFont) -> Self {
        return [.foregroundColor: color, .font: font]
    }
}

private extension CGFloat {
    static var toolBarHeight: Self { return 44 }
}
