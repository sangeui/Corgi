//
//  CategoryView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/03.
//

//
//  CategoryView.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/03.
//

import UIKit
import Combine

class GroupsView: View {
    private let viewModel: GroupsViewModel
    
    private lazy var collectionView: CategoryCollectionView = {
        let collectionView = CategoryCollectionView()
        collectionView.delegate = self
        
        return collectionView
    } ()
    
    private var lastContentOffset: CGFloat = .zero
    
    private let guideView: CorgiGuideView = .init()
    private let searchView: GroupSearchView = .init()
    private var searchViewBottomConstraint: NSLayoutConstraint? = nil
    private let emptyLabel: UILabel = .init()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: GroupsViewModel) {
        self.viewModel = viewModel
        super.init()
        
        self.setup()
        
        let tapGestureRecognizer: UITapGestureRecognizer = .init()
        tapGestureRecognizer.addTarget(self, action: #selector(self.viewDidTouched(recognizer:)))
        tapGestureRecognizer.cancelsTouchesInView = .no
        self.addGestureRecognizer(tapGestureRecognizer)

        KeyboardObserver.shared.subscribe(target: self) { event in
            switch event.type {
            case .willShow:
                guard self.searchView.isFirstResponder else { return }
                tapGestureRecognizer.cancelsTouchesInView = .yes
                if event.beginFrame.equalTo(event.endFrame) { return }
                self.searchViewBottomConstraint?.constant = .corgi.spacing.margin.minus - event.endFrame.height
                self.searchView.highlight()
            case .willHide:
                guard self.searchView.isFirstResponder else { return }
                tapGestureRecognizer.cancelsTouchesInView = .no
                self.searchViewBottomConstraint?.constant = .corgi.spacing.margin.minus
                self.searchView.dehighlight()
            case .willChangeFrame:
                guard self.searchView.isFirstResponder else { return }
                tapGestureRecognizer.cancelsTouchesInView = .yes
                self.searchViewBottomConstraint?.constant = .corgi.spacing.margin.minus - event.endFrame.height
                self.searchView.highlight()
            default: return
            }
            

            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
            
            self.collectionView.subviews.forEach({ print($0) })
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .group(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.presentBookmarkList(of: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return .init(identifier: indexPath as NSCopying, previewProvider: nil) { actions in
            let rename: UIAction = .rename { [weak self] _ in
                guard let self = self else { return }
                guard let group = self.viewModel.group(of: indexPath.row) else { return }
                
                self.viewModel.dialog(.editGroup(group: group))
            }
            
            let delete: UIAction = .delete { [weak self] _ in
                guard let self = self else { return }
                guard let group = self.viewModel.group(of: indexPath.row) else { return }
                
                self.viewModel.dialog(.confirm(action: { [weak self] in
                    let _ = self?.viewModel.requestDeletingGroup(group.identifier)
                }))
            }
            
            return .init(title: .empty, children: [rename, delete])
        }
    }
}


// MARK: - UICollectionViewDataSource
extension GroupsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfgroups
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.configureGroupCell(collectionView, of: indexPath)
    }
    
    private func configureGroupCell(_ collectionView: UICollectionView, of indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(identifier: .identifier.normal, for: indexPath) as? GroupCell,
              let group = self.viewModel.groupInformation(of: indexPath.row) else { return .init() }
        
        cell.populate(data: group)
        
        return cell
    }
}

private extension GroupsView {
    func subscribe(to publisher: AnyPublisher<[Group], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                guard let self = self else { return }
                
                self.emptyLabel.superview?.isHidden = groups.isEmpty.isNot
                UIView.transition(with: self.collectionView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.collectionView.reloadData()
                }, completion: nil)
            }
            .store(in: &self.subscriptions)
    }
}

private extension GroupsView {
    @objc func viewDidTouched(recognizer: UITapGestureRecognizer) {
        self.endEditing(.yes)
    }
}

private extension GroupsView {
    func setup() {
        self.setupCollectionView(self.collectionView, under: self)
        self.setupGuideView(self.guideView, inside: self)
        self.setupSearchView(self.searchView)
        self.setupEmptyLabel(self.emptyLabel, inside: self.collectionView)
        self.setupEffectView(.init(), inside: self)
        self.subscribe(to: self.viewModel.$groups.eraseToAnyPublisher())
    }
    
    func setupEmptyLabel(_ label: UILabel, inside parent: UIView) {
        let view = View()
        parent.addSubview(view, autolayout: .yes)
        view.leading.pin(equalTo: self.leading, constant: 20).active
        view.trailing.pin(equalTo: self.trailing, constant: -20).active
        view.top.pin(equalTo: self.safearea.top, constant: 20).active
        view.bottom.pin(equalTo: self.guideView.top, constant: -20).active
        
        view.addSubview(label, autolayout: .yes)
        label.centerx.pin(equalTo: view.centerx).active
        label.centery.pin(equalTo: view.centery).active
        label.leading.pin(equalTo: view.leading).active
        label.trailing.pin(equalTo: view.trailing).active
        
        label.text = LocalizedString("groups_empty_groups")
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.isHidden = .no
    }
    
    func setupSearchView(_ view: GroupSearchView) {
        self.addSubview(view, autolayout: .yes)
        
        view.leading.pin(equalTo: self.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: self.trailing, constant: .corgi.spacing.margin.minus).active
        self.searchViewBottomConstraint = view.bottom.pin(equalTo: self.safearea.bottom, constant: .corgi.spacing.margin.minus).activeAndReturn()
        view.height.pin(equalToConstant: .corgi.size.height(multiplier: 2)).active
        
        view.textDidChange = { [weak self] text in
            self?.viewModel.search(text)
        }
    }
    
    func setupCollectionView(_ collectionView: UICollectionView, under view: UIView) {
        view.addSubview(collectionView, autolayout: .yes)
        
        collectionView.leading.pin(equalTo: view.leading).active
        collectionView.trailing.pin(equalTo: view.trailing).active
        collectionView.top.pin(equalTo: view.safearea.top).active
        collectionView.bottom.pin(equalTo: view.safearea.bottom, constant: .corgi.spacing.margin.minus).active
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 148, right: 0)
        collectionView.allowsMultipleSelection = .no
        
        
        collectionView.register(GroupCell.self, identifier: .identifier.normal)
    }
    
    func setupGuideView(_ view: CorgiGuideView, inside parent: UIView) {
        parent.addSubview(view, autolayout: .yes)
        view.leading.pin(equalTo: parent.leading, constant: .corgi.spacing.margin).active
        view.trailing.pin(equalTo: parent.trailing, constant: .corgi.spacing.margin.minus).active
        view.bottom.pin(equalTo: parent.safearea.bottom, constant: .corgi.spacing.margin.minus * 2 - .corgi.size.height(multiplier: 2)).active
        
        view.iconImage = .icon.guide
        view.heading = .message.guideHeading
        view.subheading = .message.guideSubheading
        view.backgroundColor = .corgi.background.base
        
        let cornerRadius = CornerRadiusViewDecorator()
        view.decorate(with: cornerRadius)
    }
    
    func setupEffectView(_ view: UIVisualEffectView, inside parent: UIView) {
        parent.insertSubview(view, aboveSubview: self.collectionView)
        view.useAutoLayout
        view.leading.pin(equalTo: parent.leading).active
        view.trailing.pin(equalTo: parent.trailing).active
        view.bottom.pin(equalTo: parent.bottom).active
        view.top.pin(equalTo: self.guideView.top, constant: .corgi.spacing.margin.minus).active
        view.backgroundColor = .corgi.background.base
        view.layer.shadowOffset = .init(width: .zero, height: -3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
        
        let cornerRadius: CornerRadiusViewDecorator = .init(corner: [.leftTop, .rightTop], point: 20)
        view.decorate(with: cornerRadius)
    }
}

private extension String {
    static let identifier: Identifier = .init()
    static let message: Message = .init()
    static let actionTitle: ActionTitle = .init()
    
    struct Identifier {
        let normal = "Cell"
        let guide = "Guide"
    }
    
    struct Message {
        let guideHeading = LocalizedString("groups_edit_guide_title")
        let guideSubheading = LocalizedString("groups_edit_guide_content")
    }
    
    struct ActionTitle {
        let delete = LocalizedString("groups_delete_group")
        let rename = LocalizedString("groups_edit_name")
    }
}

private extension UIEdgeInsets {
    static func contentInset(_ view: UIView) -> Self {
        return .init(top: .zero, left: .zero, bottom: view.safeAreaInsets.bottom + 40 + 40 + 20 + 20 + 20, right: .zero)
    }
}

private extension UIImage {
    static let icon: Icon = .init()
    
    struct Icon {
        let guide: UIImage? = .init(systemName: "pencil.circle.fill")
        let delete: UIImage? = .init(systemName: "trash")
        let rename: UIImage? = .init(systemName: "pencil")
    }
}

private extension CGSize {
    static func group(_ view: UIView) -> Self {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 20
        let spacing: CGFloat = 20
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        let width = (view.bounds.width - totalSpacing)/numberOfItemsPerRow
        return CGSize(width: width, height: 75)
    }
}

private extension UIAction {
    static func delete(handler: @escaping UIActionHandler) -> UIAction {
        return .init(title: .actionTitle.delete, image: .icon.delete, attributes: [.destructive], handler: handler)
    }
    
    static func rename(handler: @escaping UIActionHandler) -> UIAction {
        return .init(title: .actionTitle.rename, image: .icon.rename, handler: handler)
    }
}
