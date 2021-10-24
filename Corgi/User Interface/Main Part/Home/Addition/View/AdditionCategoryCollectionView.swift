//
//  AdditionCategoryCollectionView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/28.
//

import UIKit

class AdditionCategoryView: View {
    var categoryDidTouched: ((String) -> Void)? = nil
    
    private var categoryList: [Group] = []
    private let stackView: UIStackView = .init()
    private let label: UILabel = .init()
    private let collectionView: AdditionCategoryCollectionView = .init()
    
    override init() {
        super.init()
        self.frame = .init(x: .zero, y: .zero, width: .zero, height: 44)
        self.setup()
    }
    
    func reloadData(_ list: [Group]) {
        self.categoryList = list
        self.collectionView.reloadData()
    }
}

private extension AdditionCategoryView {
    func setup() {
        self.backgroundColor = .init(named: "System Keyboard Color")
        let cornerRadius: CornerRadiusViewDecorator = .init(corner: [.leftTop, .rightTop])
        self.decorate(with: cornerRadius)
        
        self.setupStackView(self.stackView, under: self)
        self.setupCollectionView(self.collectionView, under: self.stackView)
    }
    
    func setupStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: view.leading, constant: 20).active
        stackView.trailing.pin(equalTo: view.trailing, constant: -20).active
        
        stackView.top.pin(equalTo: view.top, constant: 5).active
        stackView.bottom.pin(equalTo: view.bottom).active
        
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
    }
    
    func setupCollectionView(_ collectionView: UICollectionView, under stackView: UIStackView) {
        stackView.addArrangedSubview(collectionView)
        collectionView.useAutoLayout
        collectionView.height.pin(equalToConstant: 25).active
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .init(named: "System Keyboard Color")
    }
}

extension AdditionCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AdditionCategoryCollectionViewCell else {
            return .init()
        }
        
        cell.text = "\(self.categoryList[indexPath.row].name)"
        
        return cell
    }
}

extension AdditionCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categoryDidTouched?(self.categoryList[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = "#\(self.categoryList[indexPath.row].name)"
        let fontAttributes = [NSAttributedString.Key.font: UIFont.corgi.subtitle3]
           let size = (text as NSString).size(withAttributes: fontAttributes)
        
        return .init(width: size.width + 5, height: 20)
    }
}

class AdditionCategoryCollectionView: UICollectionView {
    static let cellIdentifier = "Cell"
    
    private let layout: UICollectionViewFlowLayout = .init()
    private let _frame: CGRect = .zero
    
    init() {
        self.layout.scrollDirection = .horizontal
        super.init(frame: self._frame, collectionViewLayout: self.layout)
        self.register(AdditionCategoryCollectionViewCell.self, forCellWithReuseIdentifier: Self.cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class AdditionCategoryCollectionViewCell: UICollectionViewCell {
    var text: String? {
        get { return self.label.text }
        set { self.label.text = newValue }
    }
    private let label: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        self.label.text = ""
    }
    
    private func setup() {
        self.contentView.addSubview(self.label, autolayout: .yes)
        self.label.leading.pin(equalTo: self.contentView.leading).active
        self.label.trailing.pin(equalTo: self.contentView.trailing).active
        self.label.top.pin(equalTo: self.contentView.top).active
        self.label.bottom.pin(equalTo: self.contentView.bottom).active
        
        self.label.font = .corgi.subtitle3
        self.label.textAlignment = .center
        self.label.textColor = .corgi.text.secondary
    }
}
