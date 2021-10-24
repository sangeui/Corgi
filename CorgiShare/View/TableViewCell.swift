//
//  TableViewCell.swift
//  CorgiShare
//
//  Created by 서상의 on 2021/10/04.
//

import UIKit

class TableViewCell: UITableViewCell {
    var title: String {
        get { return self.titleLabel.text ?? "" }
        set { self.titleLabel.text = newValue }
    }
    
    var input: String {
        get { return self.inputTextView.text ?? "" }
        set { self.inputTextView.text = newValue }
    }
    
    var isLocked: Bool {
        get { return self.inputTextView.isEditable == false }
        set {
            self.inputTextView.isEditable = newValue == false
            
            if newValue {
                self.editingToggleButton.setImage(.init(systemName: "lock.fill"), for: .normal)
            } else {
                self.editingToggleButton.setImage(.init(systemName: "lock.open.fill"), for: .normal)
            }
        }
    }
    
    var isEditingToggleEnabled: Bool = false {
        didSet {
            self.editingToggleButton.isHidden = isEditingToggleEnabled == false
        }
    }
    
    private var textViewTextDidChange: ((String) -> Void)? = nil
    private var textViewDidEndEditing: ((String) -> Void)? = nil
    
    private let vStackView: UIStackView = .init()
    private let hStackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let inputTextView: TextView = .init()
    private let editingToggleButton: UIButton = .init()
    
    private var textViewHeightConstraint: NSLayoutConstraint? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        self.titleLabel.text?.removeAll()
        self.inputTextView.text?.removeAll()
        self.textViewTextDidChange = nil
    }
    
    func subscribe(textViewTextDidChange action: @escaping (String) -> Void) {
        self.textViewTextDidChange = action
    }
    
    func subscribe(textViewDidEndEditing action: @escaping (String) -> Void) {
        self.textViewDidEndEditing = action
    }
}

private extension TableViewCell {
    @objc func editingToggleButtonDidTouch(sender: Any) {
        self.isLocked.toggle()
    }
}

private extension TableViewCell {
    func setup() {
        self.setupStackView(self.vStackView, under: self.contentView)
        self.setupTitleLabel(self.titleLabel, under: self.vStackView)
        self.setupHStackView(self.hStackView, under: self.vStackView)
        self.setupTextField(self.inputTextView, under: self.hStackView)
        self.setupEditingToggleButton(self.editingToggleButton, under: self.hStackView)
    }
    
    func setupEditingToggleButton(_ button: UIButton, under view: UIStackView) {
        view.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 17).isActive = true
        button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        button.setImage(.init(systemName: "lock.fill"), for: .normal)
        button.isHidden = true
        button.tintColor = .label
        button.addTarget(self, action: #selector(self.editingToggleButtonDidTouch(sender:)), for: .touchUpInside)
    }
    
    func setupStackView(_ stackView: UIStackView, under view: UIView) {
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        stackView.axis = .vertical
    }
    
    func setupHStackView(_ stackView: UIStackView, under view: UIStackView) {
        view.addArrangedSubview(stackView)
        
        stackView.alignment = .top
        stackView.spacing = 10
    }
    
    func setupTitleLabel(_ label: UILabel, under view: UIStackView) {
        view.addArrangedSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    func setupTextField(_ textView: UITextView, under view: UIStackView) {
        view.addArrangedSubview(textView)
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        textView.tintColor = .systemOrange
    }
}

extension TableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textViewTextDidChange?(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        textView.text = trimmed
        
        self.textViewDidEndEditing?(trimmed)
    }
}

class TextView: UITextView {
    override var isEditable: Bool {
        didSet {
            if self.isEditable {
                self.textColor = self.textColor?.withAlphaComponent(1.0)
            } else {
                self.textColor = self.textColor?.withAlphaComponent(0.2)
            }
        }
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
