//
//  HomeTableViewCell.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/18.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    var urlString: String? {
        get { self.urlLabel.text }
        set { self.urlLabel.text = newValue }
    }
    
    var urlCategory: String? {
        get { self.categoryLabel.text }
        set { self.categoryLabel.text = newValue }
    }
    
    var urlDescription: String? {
        get { self.descriptionLabel.text }
        set { self.descriptionLabel.text = newValue }
    }
    
    var isHiddenCircleView: Bool {
        get { self.circleView.isHidden }
        set { self.circleView.isHidden = newValue }
    }
    
    private let horizontalStackView: UIStackView = .init()
    
    private let urlImageView: UIImageView = .init()
    private let verticalStackView: UIStackView = .init()
    private let circleView: UIImageView = .init()
    
    private let urlLabel: UILabel = .init()
    private let categoryLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.urlImageView.image = .init(systemName: "link.circle.fill")
        self.urlImageView.cancelImageLoad()
        self.urlImageView.backgroundColor = .clear
        self.urlString?.removeAll()
        self.urlDescription?.removeAll()
//        self.isHiddenCircleView = .yes
    }
    
    func loadFavicon(at url: URL) {
        self.urlImageView.loadImage(at: url)
    }
}

private extension BookmarkTableViewCell {
    func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.setupCircleImageView(self.circleView, inside: self.contentView)
        self.setupHorizontalStackView(self.horizontalStackView, inside: self.contentView, next: self.circleView)
        self.setupURLimageView(self.urlImageView, under: self.horizontalStackView)
        self.setupVerticalStackView(self.verticalStackView, under: self.horizontalStackView)
        
        self.setupCategoryLabel(self.categoryLabel, under: self.verticalStackView)
        self.setupURLlabel(self.urlLabel, under: self.verticalStackView)
        self.setupDescriptionLabel(self.descriptionLabel, under: self.verticalStackView)
    }
    
    func setupHorizontalStackView(_ stackView: UIStackView, inside view: UIView, next sibling: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: .corgi.spacing.padding).active
        stackView.trailing.pin(equalTo: sibling.leading, constant: .corgi.spacing.padding.minus).active
        stackView.top.pin(equalTo: view.top, constant: .corgi.spacing.padding).active
        stackView.bottom.pin(equalTo: view.bottom, constant: .corgi.spacing.padding.minus).active
        
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 20
    }
    
    func setupURLimageView(_ imageView: UIImageView, under stackView: UIStackView) {
        stackView.addArrangedSubview(imageView)
        
        imageView.useAutoLayout
        imageView.height.pin(equalToConstant: .imageViewSize).active
        imageView.width.pin(equalToConstant: .imageViewSize).active
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
        
        imageView.clipsToBounds = .yes
        imageView.image = .init(systemName: "link.circle.fill")
        imageView.layer.cornerRadius = 3
    }
    
    func setupVerticalStackView(_ childStackView: UIStackView, under parentStackView: UIStackView) {
        parentStackView.addArrangedSubview(childStackView)
        
        childStackView.axis = .vertical
    }
    
    func setupCircleImageView(_ imageView: UIImageView,inside view: UIView) {
        view.addSubview(imageView, autolayout: .yes)
        
        imageView.trailing.pin(equalTo: self.trailing, constant: -8).active
        imageView.width.pin(equalToConstant: 7).active
        imageView.centery.pin(equalTo: self.centery).active
        imageView.contentMode = .scaleAspectFit
        imageView.image = .circle
        imageView.tintColor = .systemOrange
    }
    
    func setupURLlabel(_ label: UILabel, under stackView: UIStackView) {
        stackView.addArrangedSubview(label)
        stackView.setCustomSpacing(3, after: label)
        
        label.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    func setupCategoryLabel(_ label: UILabel, under stackView: UIStackView) {
        stackView.addArrangedSubview(label)
        
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 10, weight: .light)
    }
    
    func setupDescriptionLabel(_ label: UILabel, under stackView: UIStackView) {
        stackView.addArrangedSubview(label)
        
        label.font = .systemFont(ofSize: 10, weight: .light)
    }
}

private extension CGFloat {
    static let imageViewSize: CGFloat = 20
}

private extension UIImage {
    static let circle: UIImage? = .init(systemName: "circle.fill")
}

