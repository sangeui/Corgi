//
//  AdditionView.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/14.
//

import UIKit
import Combine

class AdditionView: View {
    private let viewModel: AdditionViewModel
    
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    
    private let categoryView: AdditionCategoryView = .init()
    
    private let urlTextField: AdditionTextField = .init()
    private let categoryTextField: AdditionTextField = .init()
    private let descriptionTextField: AdditionTextField = .init()
    
    private let saveButton: UIButton = .init()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: AdditionViewModel) {
        self.viewModel = viewModel
        super.init()
        self.setup()
        
        self.categoryView.categoryDidTouched = { [weak self] category in
            self?.categoryTextField.text = ""
            self?.categoryTextField.text = category
            self?.viewModel.userDidEnterCategory(category: category)
        }
    }
}

extension AdditionView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(self.categoryTextField) {
            textField.inputAccessoryView = self.categoryView
            self.viewModel.requestCategoryList()
        } else {
            textField.inputAccessoryView = .init()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        defer { textField.resignFirstResponder() }
        
        if textField.isEqual(self.urlTextField) {
            _ = self.categoryTextField.becomeFirstResponder()
        } else if textField.isEqual(self.categoryTextField) {
            _ = self.descriptionTextField.becomeFirstResponder()
        }
        
        return .yes
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(self.urlTextField) {
            self.viewModel.userDidEnterURLtext(urlText: textField.text ?? .empty)
        } else if textField.isEqual(self.categoryTextField) {
            self.viewModel.userDidEnterCategory(category: textField.text ?? .empty)
        } else if textField.isEqual(self.descriptionTextField) {
            self.viewModel.userDidEnterDescription(description: textField.text ?? .empty)
        }
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if textField.isEqual(self.urlTextField) {
            self.viewModel.userDidEnterURLtext(urlText: textField.text ?? .empty)
        } else if textField.isEqual(self.categoryTextField) {
            self.viewModel.userDidEnterCategory(category: textField.text ?? .empty)
        } else if textField.isEqual(self.descriptionTextField) {
            self.viewModel.userDidEnterDescription(description: textField.text ?? .empty)
        }
    }
}

private extension AdditionView {
    func subscribe(to publisher: AnyPublisher<UnfinishedBookmark?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmark in
                self?.urlTextField.text = bookmark?.addressString
                self?.categoryTextField.text = bookmark?.category
                self?.descriptionTextField.text = bookmark?.description
                
                self?.viewModel.userDidEnterURLtext(urlText: self?.urlTextField.text ?? "")
                self?.viewModel.userDidEnterCategory(category: self?.categoryTextField.text ?? "")
                self?.viewModel.userDidEnterDescription(description: self?.descriptionTextField.text ?? "")
            }
            .store(in: &self.subscriptions)
    }
    
    func subscribe(to publisher: AnyPublisher<Bool, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.saveButton.isEnabled = $0 }
            .store(in: &self.subscriptions)
    }
    
    func subscribe(to publisher: AnyPublisher<[Group], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categoryList in
                guard let self = self else { return }
                self.categoryView.reloadData(categoryList)
            }
            .store(in: &self.subscriptions)
    }
}

private extension AdditionView {
    func setup() {
        self.setupTitleLabel(self.titleLabel)
        self.setupStackView(self.stackView)
        self.subscribe(to: self.viewModel.$buttonEnabled.eraseToAnyPublisher())
        self.subscribe(to: self.viewModel.$categoryList.eraseToAnyPublisher())
        self.subscribe(to: self.viewModel.$unfinishedBookmark.eraseToAnyPublisher())
    }
    
    func setupTitleLabel(_ label: UILabel) {
        self.addSubview(label, autolayout: .yes)
        
        label.leading.pin(equalTo: self.leading, constant: .corgi.spacing.margin).active
        label.trailing.pin(equalTo: self.trailing, constant: .corgi.spacing.margin.minus).active
        label.top.pin(equalTo: self.safearea.top, constant: .corgi.spacing.margin).active
        
        label.font = .mainTitleFont
        label.text = LocalizedString("addition_title")
    }
    
    func setupStackView(_ stackView: UIStackView) {
        self.addSubview(stackView, autolayout: .yes)
        
        stackView.leading.pin(equalTo: self.leading, constant: .corgi.spacing.margin).active
        stackView.trailing.pin(equalTo: self.trailing, constant: .corgi.spacing.margin.minus).active
        stackView.top.pin(equalTo: self.titleLabel.bottom, constant: .corgi.spacing.margin).active
        stackView.bottom.pin(lessThanOrEqualTo: self.bottom, constant: .corgi.spacing.margin.minus).active
        
        stackView.spacing = .spacing
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        self.setupURLtextField(self.urlTextField, placeholder: .urlTextFieldPlacholder)
        stackView.addArrangedSubview(self.urlTextField)
        
        self.setupCategoryTextField(self.categoryTextField, placeholder: .categoryTextFieldPlaceholder)
        stackView.addArrangedSubview(self.categoryTextField)
        
        self.setupDescriptionTextField(self.descriptionTextField, placeholder: .descriptionTextFieldPlacholder)
        stackView.addArrangedSubview(self.descriptionTextField)
        
        self.setupSaveButton(self.saveButton)
        stackView.addArrangedSubview(self.saveButton)
        
    }
    
    func setupURLtextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        self.setupAdditionTextField(textField)
    }
    
    func setupCategoryTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        
        self.setupAdditionTextField(textField)
    }
    
    func setupDescriptionTextField(_ textField: UITextField, placeholder: String)  {
        textField.placeholder = placeholder
        self.setupAdditionTextField(textField)
    }
    
    func setupAdditionTextField(_ textField: UITextField) {
        textField.useAutoLayout
        textField.heightAnchor.pin(equalToConstant: .textFieldHeight).active
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 13, weight: .medium)
        
        let bottomBorderDecorator: BottomBorderDecorator = .init()
        textField.decorate(with: bottomBorderDecorator)
        
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupSaveButton(_ button: UIButton) {
        button.useAutoLayout
        button.height.pin(equalToConstant: .buttonHeight).active
        
        button.titleLabel?.font = .buttonTitleFont
        button.setTitle(.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black.withAlphaComponent(0.3), for: .disabled)
        button.backgroundColor = .systemOrange
        
        let cornerRadiusDecorator: CornerRadiusViewDecorator = .init()
        button.decorate(with: cornerRadiusDecorator)
        
        button.addTarget(self.viewModel, action: #selector(self.viewModel.userDidTouchSaveButton), for: .touchUpInside)
    }
}

private extension String {
    static var urlTextFieldPlacholder: String { return "https://www.apple.com" }
    static var categoryTextFieldPlaceholder: String { return LocalizedString("addition_placeholder_group") }
    static var descriptionTextFieldPlacholder: String { return LocalizedString("addition_placeholder_description") }
    static var buttonTitle: String { return LocalizedString("addition_button_save") }
}

private extension UIColor {
    static var subTitleColor: UIColor { return .systemGray }
}

private extension UIFont {
    static var mainTitleFont: UIFont { return .systemFont(ofSize: 20, weight: .heavy) }
    static var subTitleFont: UIFont { return .systemFont(ofSize: 13, weight: .semibold) }
    static var buttonTitleFont: UIFont { return .systemFont(ofSize: 13, weight: .semibold) }
}

private extension CGFloat {
    static var spacing: CGFloat { return 8 }
    static var textFieldHeight: CGFloat { return 44 }
    static var buttonHeight: CGFloat { return 44 }
}
