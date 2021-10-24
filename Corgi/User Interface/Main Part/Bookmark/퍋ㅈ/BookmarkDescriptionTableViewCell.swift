//
//  BookmarkTableViewCell.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/07.
//

import UIKit

class BookmarkDescriptionTableViewCell: UITableViewCell {
    var heading: String {
        get { self.headingLabel.text ?? "" }
        set { self.headingLabel.text = newValue }
    }
    
    var subheading: String? {
        get { self.subheadingLabel.text ?? "" }
        set { self.subheadingLabel.text = newValue }
    }
    
    private let stackView: UIStackView = .init()
    private let headingLabel: UILabel = .init()
    private let subheadingLabel: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension BookmarkDescriptionTableViewCell {
    func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.setupStackView(self.stackView, inside: self.contentView)
        self.setupHeadingLabel(self.headingLabel, inside: self.stackView)
        self.setupSubheadingLabel(self.subheadingLabel, inside: self.stackView)
    }
    
    func setupStackView(_ stackView: UIStackView, inside view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        stackView.stretch(into: view, padding: .corgi.spacing.padding)
        stackView.axis = .vertical
        stackView.spacing = 4
    }
    
    func setupHeadingLabel(_ label: UILabel, inside view: UIStackView) {
        view.addArrangedSubview(label)
        label.font = .corgi.caption1
        label.textColor = .corgi.text.secondary
    }
    
    func setupSubheadingLabel(_ label: UILabel, inside view: UIStackView) {
        view.addArrangedSubview(label)
        label.font = .corgi.subTitle5
        label.numberOfLines = .zero
    }
}
