//
//  SettingsViewController.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/18.
//

import UIKit
import Combine
import MessageUI

class SettingsViewController: ViewController, TitleImageViewSettable {
    private let viewModel: SettingsViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = SettingsView(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleImageView(with: .init(named: "Settings Title"))
        self.subscribe(to: self.viewModel.$dialog.eraseToAnyPublisher())
    }
}

private extension SettingsViewController {
    func subscribe(to publisher: AnyPublisher<SettingsDialog?, Never>) {
        publisher
            .subscribe(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] in self?.present(dialog: $0) }
            .store(in: &self.subscriptions)
    }
    
    func present(dialog: SettingsDialog) {
        switch dialog {
        case .confirm(action: let action):
            let controller = UIAlertController()
            controller.title = LocalizedString("settings_dialog_clear_title")
            controller.message = LocalizedString("settings_dialog_clear_content")
            
            let cancel = UIAlertAction(title: LocalizedString("settings_dialog_cancel"), style: .default, handler: { _ in })
            let confirm = UIAlertAction(title: LocalizedString("settings_dialog_confirm"), style: .destructive, handler: { _ in action() })
            
            cancel.setValue(UIColor.label, forKey: "titleTextColor")
            controller.addAction(confirm)
            controller.addAction(cancel)
            
            self.present(controller, animated: .yes, completion: nil)
        case .changeUserInterfaceStyle(let action):
            let controller = UIAlertController(title: LocalizedString("settings_dialog_uistyle_title"), message: nil, preferredStyle: .actionSheet)
            let actions: [UIAlertAction] = UIUserInterfaceStyle.allCases.map({ style in
                let action = UIAlertAction(title: style.title, style: .default, handler: { _ in action(style.rawValue) })
                action.setValue(UIColor.label, forKey: "titleTextColor")
                return action
            })
            actions.forEach(controller.addAction(_:))
            
            self.present(controller, animated: .yes, completion: nil)
        case .sendEmail:
            guard MFMailComposeViewController.canSendMail() else { return }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["welsh.corgi.happy@gmail.com"])
            
            self.present(mail, animated: .yes, completion: nil)
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIUserInterfaceStyle: CaseIterable {
    public static var allCases: [UIUserInterfaceStyle] {
        return [.light, .dark, .unspecified]
    }
    
    var title: String {
        switch self {
        case .light: return LocalizedString("settings_uistyle_light")
        case .dark: return LocalizedString("settings_uistyle_dark")
        case .unspecified: return LocalizedString("settings_uistyle_default")
        @unknown default: fatalError()
        }
    }
}
