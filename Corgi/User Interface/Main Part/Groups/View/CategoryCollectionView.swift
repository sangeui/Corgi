//
//  CategoryCollectionView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/03.
//

import UIKit

class CategoryCollectionView: UICollectionView {
    private var visualEffectView: UIVisualEffectView? = nil
    private let scrollDirection: UICollectionView.ScrollDirection
    
    init(direction: UICollectionView.ScrollDirection = .vertical) {
        self.scrollDirection = direction
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 20, left: 20, bottom: .zero, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = direction
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
