//
//  Extension+UICollectionView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/06.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass?, identifier: String) {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeue(identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
