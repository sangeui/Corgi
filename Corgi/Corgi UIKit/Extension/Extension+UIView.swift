//
//  Extension+UIView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/06.
//

import UIKit

extension UIView {
    var useAutoLayout: Void { self.translatesAutoresizingMaskIntoConstraints = false }
    
    func addSubview(_ view: UIView, autolayout: Bool) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = !autolayout
    }
}

extension UIView {
    var leading: NSLayoutXAxisAnchor { return self.leadingAnchor }
    var trailing: NSLayoutXAxisAnchor { return self.trailingAnchor }
    var top: NSLayoutYAxisAnchor { return self.topAnchor }
    var bottom: NSLayoutYAxisAnchor { return self.bottomAnchor }
    var centerx: NSLayoutXAxisAnchor { return self.centerXAnchor }
    var centery: NSLayoutYAxisAnchor { return self.centerYAnchor }
    var height: NSLayoutDimension { return self.heightAnchor }
    var width: NSLayoutDimension { return self.widthAnchor }
    var safearea: UILayoutGuide { return self.safeAreaLayoutGuide }
}

// MARK: View Decorator Pattern
extension UIView {
    func decorate(with decorator: ViewDecorator) {
        decorator.decorate(view: self)
    }
}

extension UIView {
    func stretch(into view: UIView, padding: CGFloat) {
        guard self.isDescendant(of: view) else { fatalError() }
        
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
    }
}

extension UITableView {
    func register(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func dequeue(identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
