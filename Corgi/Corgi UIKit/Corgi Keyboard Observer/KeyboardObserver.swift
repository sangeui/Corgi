//
//  CorgiKeyboardObserver.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/02.
//

import UIKit

class KeyboardObserver {
    static var shared: KeyboardObserver = .init()
    
    private let notificationCenter: NotificationCenter = .default
    private var subscribers: [AnyHashable: (CorgiKeyboardEvent) -> Void] = [:]
    
    private init() {
        CorgiKeyboardEventName.allCases.forEach(self.register(corgiKeyboardEvent:))
    }
    
    deinit {
        self.subscribers.removeAll()
        CorgiKeyboardEventName.allCases.forEach(self.release(corgiKeyboardEvent:))
    }
    
    func subscribe(target: AnyHashable, event: @escaping ((CorgiKeyboardEvent) -> Void)) {
        self.subscribers.updateValue(event, forKey: target)
        print()
        print("🐕 Corgi Keyboard Observer Alert")
        print("     📰 \(target.hashValue) was just subscribed")
        print()
    }
    
    func unsubscribe(target: AnyHashable?) {
        guard let target = target else { return }
        
        if let _ = self.subscribers.removeValue(forKey: target) {
            print()
            print("🐕 Corgi Keyboard Observer Alert")
            print("     🗑 \(target.hashValue) was just unsubscribed")
            print()
        }
    }
}

private extension KeyboardObserver {
    @objc func keyboardEventDidOccur(notification: Notification) {
        guard let event = CorgiKeyboardEvent(notification: notification) else { return }
        
        self.subscribers.forEach({ _, value in value(event) })
    }
    
    private func register(corgiKeyboardEvent: CorgiKeyboardEventName) {
        self.notificationCenter.addObserver(self, selector: #selector(self.keyboardEventDidOccur(notification:)),
                                            name: corgiKeyboardEvent.notificationName,
                                            object: nil)
    }
    
    private func release(corgiKeyboardEvent: CorgiKeyboardEventName) {
        self.notificationCenter.removeObserver(self,
                                               name: corgiKeyboardEvent.notificationName,
                                               object: nil)
    }
}

struct CorgiKeyboardEvent {
    let type: CorgiKeyboardEventName
    let beginFrame: CGRect
    let endFrame: CGRect
    
    init?(notification: Notification) {
        guard let userInfo = notification.userInfo else { return nil }
        guard let beginFrame = userInfo.beginFrame else { return nil }
        guard let endFrame = userInfo.endFrame else { return nil }
        guard let type = CorgiKeyboardEventName(name: notification.name) else { return nil }
        
        self.type = type
        self.beginFrame = beginFrame
        self.endFrame = endFrame
    }
}

enum CorgiKeyboardEventName: CaseIterable {
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame
}

extension CorgiKeyboardEventName {
    init?(name: Notification.Name) {
        switch name {
        case .keyboardWillShowNotification: self = .willShow
        case .keyboardDidShowNotification: self = .didShow
        case .keyboardWillHideNotification: self = .willHide
        case .keyboardDidHideNotification: self = .didHide
        case .keyboardWillChangeFrameNotification: self = .willChangeFrame
        case .keyboardDidChangeFrameNotification: self = .didChangeFrame
        default: return nil
        }
    }
    
    var notificationName: Notification.Name {
        switch self {
        case .willShow: return .keyboardWillShowNotification
        case .didShow: return .keyboardDidShowNotification
        case .willHide: return .keyboardWillHideNotification
        case .didHide: return .keyboardDidHideNotification
        case .willChangeFrame: return .keyboardWillChangeFrameNotification
        case .didChangeFrame: return .keyboardDidChangeFrameNotification
        }
    }
}

private extension Dictionary where Key == AnyHashable, Value == Any {
    var beginFrame: CGRect? {
        return (self[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var endFrame: CGRect? {
        return (self[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
}

private extension Notification.Name {
    static let keyboardWillShowNotification = UIResponder.keyboardWillShowNotification
    static let keyboardDidShowNotification = UIResponder.keyboardDidShowNotification
    static let keyboardWillHideNotification = UIResponder.keyboardWillHideNotification
    static let keyboardDidHideNotification = UIResponder.keyboardDidHideNotification
    static let keyboardWillChangeFrameNotification = UIResponder.keyboardWillChangeFrameNotification
    static let keyboardDidChangeFrameNotification = UIResponder.keyboardDidChangeFrameNotification
}
