//
//  CategoryCollectionViewCell.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/03.
//

import UIKit

class GroupCell: UICollectionViewCell {
    var name: String {
        get { return self.nameLabel.text ?? "" }
        set { self.nameLabel.text = newValue }
    }
    
    var count: String {
        get { return self.countLabel.text ?? "" }
        set { self.countLabel.text = newValue }
    }
    
    private let stackView: UIStackView = .init()
    private let nameLabel: UILabel = .init()
    private let countLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.nameLabel.text?.removeAll()
        self.countLabel.text?.removeAll()
    }
    
    func populate(data: (String, Int)) {
        self.nameLabel.text = data.0
        self.countLabel.text = "\(data.1)"
    }
}

private extension GroupCell {
    func setup() {
        let shadowDecorator: ShadowViewDecorator = .init()
        self.decorate(with: shadowDecorator)
        self.backgroundColor = .corgi.background.grouped
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        self.decorate(with: cornerRadiusDecorator)
        
        self.setupStackView(self.stackView, under: self.contentView)
        self.setupNameLabel(self.nameLabel, under: self.stackView)
        self.setupCountLabel(self.countLabel, under: self.stackView)
    }
    
    func setupStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: .corgi.spacing.padding).active
        stackView.trailing.pin(equalTo: view.trailing, constant: .corgi.spacing.padding.minus).active
        stackView.top.pin(equalTo: view.top, constant: .corgi.spacing.padding).active
        stackView.bottom.pin(equalTo: view.bottom, constant: .corgi.spacing.padding.minus).active
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 4
    }
    
    func setupNameLabel(_ label: UILabel, under view: UIStackView) {
        view.addArrangedSubview(label)
        label.adjustsFontSizeToFitWidth = .yes
        label.numberOfLines = 2
        label.font = .corgi.subtitle3
    }
    
    func setupCountLabel(_ label: UILabel, under view: UIStackView) {
        view.addArrangedSubview(label)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .corgi.header1
    }
}
