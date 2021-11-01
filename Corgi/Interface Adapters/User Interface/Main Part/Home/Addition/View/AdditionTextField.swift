//
//  AdditionTextField.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/15.
//

import UIKit

class AdditionTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        self.decorate(with: cornerRadiusDecorator)
        
        let leftView: UIView = .init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        self.leftView = leftView
        self.leftViewMode = .always
        
        self.font = .corgi.subtitle3
        self.tintColor = .corgi.text.secondary
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func becomeFirstResponder() -> Bool {
        UIView.animate(withDuration: 0.25, delay: .zero, options: [.allowUserInteraction]) {
            self.backgroundColor = .corgi.background.grouped
            self.clipsToBounds = .yes
        } completion: { success in
            if success.isNot {
                self.clipsToBounds = .no
                self.backgroundColor = .clear
            }
        }

        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        UIView.animate(withDuration: 0.25, delay: .zero, options: [.allowUserInteraction]) {
            self.backgroundColor = .clear
        } completion: { success in
            if success.isNot {
                self.backgroundColor = .corgi.background.grouped
                self.clipsToBounds = .yes
            } else {
                self.clipsToBounds = .no
            }
        }

        return super.resignFirstResponder()
    }
}
