//
//  GroupSelectView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/08.
//

import UIKit
import Combine

class GroupSelectView: View {
    private let viewModel: GroupSelectViewModel
    
    private let searchView: GroupSearchView = .init()
    private let stackView: UIStackView = .init()
    private var stackViewBottomConstraint: NSLayoutConstraint? = nil
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let `self` = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return `self`
    }()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(viewModel: GroupSelectViewModel) {
        self.viewModel = viewModel
        super.init()
        self.setup()
        
        self.viewModel.$groups.eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { _ in self.collectionView.reloadData() }
            .store(in: &self.subscriptions)
        
        KeyboardObserver.shared.subscribe(target: self) { event in
            switch event.type {
            case .willShow:
                UIView.animate(withDuration: 0.25) {
                    if event.beginFrame.equalTo(event.endFrame) {
                        return
                    }
                    
                    let origin = self.frame.origin
                    let newOrigin: CGPoint = .init(x: origin.x, y: origin.y - (event.beginFrame.origin.y - event.endFrame.origin.y))
                    self.frame.origin = newOrigin
                    self.searchView.highlight()
                }
            case .willHide:
                UIView.animate(withDuration: 0.25) {
                    let origin = self.frame.origin
                    let newOrigin: CGPoint = .init(x: origin.x, y: origin.y + event.beginFrame.height)
                    self.frame.origin = newOrigin
                    self.searchView.highlight()
                }
            default: break
            }

        }
    }
}

extension GroupSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = self.viewModel.groups[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GroupSelectCell
        cell.name = group.name
        
        return cell
    }
}

extension GroupSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 40
        let spacing: CGFloat = 20
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        return CGSize(width: width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.select(group: indexPath.row)
    }
}

private extension GroupSelectView {
    func setup() {
        self.backgroundColor = .systemBackground
        self.setupSearchView(self.searchView, inside: self)
        self.setupStackView(self.stackView, inside: self, below: self.searchView)
        self.setupCollectionView(self.collectionView, inside: self.stackView)
    }
    
    func setupSearchView(_ view: GroupSearchView, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        view.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        view.top.pin(equalTo: parent.safearea.top, constant: .corgi.spacing.margin).active
        view.height.pin(equalToConstant: 44).active
        
        view.textDidChange = { [weak self] text in
            self?.viewModel.search(text)
        }
        
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = .zero
        view.layer.shadowOpacity = .zero
        
        let border = BorderDecorator()
        view.decorate(with: border)
    }
    
    func setupStackView(_ stackView: UIStackView, inside parent: UIView, below sibling: UIView) {
        parent.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: parent.leading, constant: .zero).active
        stackView.trailing.pin(equalTo: parent.trailing, constant: .zero).active
        stackView.top.pin(equalTo: sibling.bottom, constant: .zero).active
        stackView.height.pin(equalToConstant: 150).active
        stackView.bottom.pin(equalTo: parent.safearea.bottom).active
    }
    
    func setupCollectionView(_ collectionView: UICollectionView, inside parent: UIStackView) {
        parent.addArrangedSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GroupSelectCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = .no
    }
}

class GroupSelectCell: UICollectionViewCell {
    var name: String {
        get { return self.nameLabel.text ?? "" }
        set { self.nameLabel.text = newValue }
    }
    
    private let nameLabel: UILabel = .init()
    
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
    }
}

private extension GroupSelectCell {
    func setup() {
        self.backgroundColor = .corgi.background.grouped
        
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        self.decorate(with: cornerRadiusDecorator)
        
        let shadow: ShadowViewDecorator = .init()
        self.decorate(with: shadow)
        
        self.setupLabel(self.nameLabel, inside: self.contentView)
        
    }
    
    func setupLabel(_ label: UILabel, inside parent: UIView) {
        parent.addSubview(label, autolayout: .yes)
        label.stretch(into: parent, padding: .corgi.spacing.margin)
        label.font = .corgi.subTitle4
        label.textAlignment = .center
        
    }
}
