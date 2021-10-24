//
//  ShareViewController.swift
//  CorgiShare
//
//  Created by 서상의 on 2021/09/29.
//

import UIKit
import Social
import CorgiStorage

@objc(ViewController)
class ViewController: UITableViewController {
    private var targetURL: URL? = nil {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    
    private let test: CoreDataInterface? = .init()
    private let button: Button = .init()
    
    private var modifiedURL: String = ""
    private var category: String = ""
    private var explanation: String = ""
    
    init() {
        super.init(style: .insetGrouped)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.startLoadingURL()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(with: "TableViewCell", for: indexPath) as? TableViewCell ?? .init()
        
        if indexPath.needsURLstring {
            cell.input = self.targetURL?.absoluteString ?? ""
        }
        
        cell.title = indexPath.title
        cell.isEditingToggleEnabled = indexPath.canToggleEditingButton
        cell.isLocked = indexPath.needsToBeLocked
        cell.subscribe(textViewTextDidChange: { [weak self] text in
            self?.textViewTextDidChange(text: text)
        })
        
        cell.subscribe(textViewDidEndEditing: { [weak self] text in
            self?.textViewDidEndEditing(text: text, from: indexPath)
        })
    
        return cell
    }
    
    func textViewTextDidChange(text: String) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func textViewDidEndEditing(text: String, from indexPath: IndexPath) {
        defer {
            self.button.isEnabled = self.checkIfButtonCanBeActive()
        }
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        if indexPath.isURL {
            self.modifiedURL = text
            return
        }
        
        if indexPath.isCategory {
            self.category = text
            return
        }
        
        if indexPath.isExplanation {
            self.explanation = text
            return
        }
    }
}

private extension ViewController {
    func checkIfButtonCanBeActive() -> Bool {
        guard URL(string: self.modifiedURL) != nil ||
                self.targetURL != nil else { return false }
        guard self.category.isEmpty == false else { return false }
        guard self.explanation.isEmpty == false else { return false }
        
        return true
    }
    
    func startLoadingURL() {
        guard let extensionItemList = self.extensionContext?.inputItems,
              let extensionItem = extensionItemList.first as? NSExtensionItem,
              let itemProviderList = extensionItem.attachments,
              let itemProvider = itemProviderList.first,
              itemProvider.hasItemConformingToTypeIdentifier("public.url") else { return }
        
        itemProvider.loadItem(forTypeIdentifier: "public.url",
                              options: nil,
                              completionHandler: self.load(secureCoding:error:))
    }
    func load(secureCoding: NSSecureCoding?, error: Error?) {
        guard let url = secureCoding as? URL else { return }
        
        self.targetURL = url
    }
}

private extension ViewController {
    @objc func viewDidTouch(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func buttonDidTouch(sender: Any) {
        var url: URL? = nil
        
        url = .init(string: self.modifiedURL)
        
        if url == nil {
            url = self.targetURL
        }
        
        guard let url = url else { return }
        
        let bookmark: BookmarkRM = .init(url: url, group: self.category, description: self.explanation, identifier: .init(), dateCreated: .init(), isOpened: false)
        
        guard let storage = self.test else { return }
        guard storage.createBookmark(bookmark) else { return }
        
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

private extension ViewController {
    func setup() {
        self.view.backgroundColor = .systemBackground
        self.setupTapGestureRecognizer()
        self.setupTitleView()
        self.setupButton(self.button, under: self.view)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func setupTapGestureRecognizer() {
        let recognizer: UITapGestureRecognizer = .init()
        recognizer.addTarget(self, action: #selector(self.viewDidTouch(recognizer:)))
        recognizer.cancelsTouchesInView = true
        
        self.view.addGestureRecognizer(recognizer)
    }
    
    func setupTitleView() {
        let imageView: UIImageView = UIImageView(image: .init(named: "Corgi")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .label
        self.navigationItem.titleView = imageView
    }
    
    func setupButton(_ button: UIButton, under view: UIView) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        button.isEnabled = false
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.addTarget(self, action: #selector(self.buttonDidTouch(sender:)), for: .touchUpInside)
    }
}

private extension UITableView {
    func dequeue(with identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

private extension IndexPath {
    var title: String {
        switch self.row {
        case .zero: return "URL"
        case 1: return "그룹"
        case 2: return "설명"
        default: return ""
        }
    }
    
    var canToggleEditingButton: Bool { return self.row == .zero }
    var needsURLstring: Bool { return self.row == .zero }
    var needsToBeLocked: Bool { return self.row == .zero }
    
    var isURL: Bool { return self.row == 0 }
    var isCategory: Bool { return self.row == 1 }
    var isExplanation: Bool { return self.row == 2 }
}
