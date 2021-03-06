//
//  SceneDelegate.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let appearanceUserCaseInteractor: AppearanceUseCaseInteractor = .init(dataAccessInterface: AppearanceUserDefaults())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = .init(windowScene: windowScene)
        
        let rootViewController: UIViewController
        
        if let container: MainDependencyContainer = .init(userInterfaceResponder: self) {
            rootViewController = container.createMainViewController()
        } else {
            rootViewController = .init()
        }
        
        self.appearanceUserCaseInteractor.outputBoundary = self
        self.appearanceUserCaseInteractor.read()

        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = rootViewController
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CorgiPasteboard.shared.temp(bool: true)
    }
}

extension SceneDelegate: AppearanceUseCaseOutputBoundary {
    func send(appearance: Int) {
        let userInterfaceStyle: UIUserInterfaceStyle = .init(rawValue: appearance) ?? .unspecified
        self.window?.windowScene?.windows.forEach({ $0.overrideUserInterfaceStyle = userInterfaceStyle })
    }
}

extension SceneDelegate: UserInterfaceStyleResponder {
    func transition(to style: UserInterfaceStyle) {
        let userInterfaceStyle = self.matchedUIuserInterfaceStyle(given: style)
        UIApplication.shared.transitionUIstyle(to: userInterfaceStyle)
    }
    
    private func matchedUIuserInterfaceStyle(given rawValue: Int) -> UIUserInterfaceStyle {
        return .init(rawValue: rawValue) ?? .unspecified
    }
}

extension UIApplication {
    func transitionUIstyle(to style: UIUserInterfaceStyle) {
        (self.connectedScenes.first?.delegate as? SceneDelegate)?.window?.windowScene?.windows.forEach({ window in
            UIView.transition(with: window, duration: 0.25, options: [.allowUserInteraction, .transitionCrossDissolve], animations: {
                window.overrideUserInterfaceStyle = style
            }, completion: nil)
        })
    }
}

protocol UserInterfaceStyleResponder {
    typealias UserInterfaceStyle = Int
    func transition(to style: UserInterfaceStyle)
}
