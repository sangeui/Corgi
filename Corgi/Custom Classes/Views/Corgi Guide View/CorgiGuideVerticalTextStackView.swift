//
//  CorgiGuideVerticalTextStackView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/06.
//

import UIKit

class CorgiGuideVerticalTextStackView: UIStackView {
    var heading: String {
        get { self.headingLabel.text ?? "" }
        set { self.headingLabel.text = newValue }
    }
    
    var subheading: String {
        get { self.subHeadingLabel.text ?? "" }
        set { self.subHeadingLabel.text = newValue }
    }
    
    var textColor: UIColor = .label {
        didSet {
            self.headingLabel.textColor = textColor
            self.subHeadingLabel.textColor = textColor
        }
    }
    
    private let headingLabel: UILabel = .init()
    private let subHeadingLabel: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

private extension CorgiGuideVerticalTextStackView {
    func setup() {
        self.distribution = .fillProportionally
        self.axis = .vertical
        
        self.setupHeadingLabel(self.headingLabel, under: self)
        self.setupSubHeadingLabel(self.subHeadingLabel, under: self)
    }
    
    func setupHeadingLabel(_ label: UILabel, under view: UIStackView) {
        view.addArrangedSubview(label)
        label.font = .corgi.subTitle4
    }
    
    func setupSubHeadingLabel(_ label: UILabel, under view: UIStackView) {
        view.addArrangedSubview(label)
        label.font = .corgi.subTitle5
        label.textColor = .corgi.text.secondary
    }
}

private extension UIFont {
    static let heading: UIFont = .systemFont(ofSize: 12, weight: .semibold)
    static let subheading: UIFont = .systemFont(ofSize: 11, weight: .medium)
}
